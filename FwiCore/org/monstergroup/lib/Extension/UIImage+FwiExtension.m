#import <float.h>
#import "FwiCore.h"
#import "UIImage+FwiExtension.h"


@implementation UIImage (FwiCreation)


+ (__autoreleasing UIImage *)imageWithName:(NSString *)name {
    NSInteger version = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && version < 7) {
        __autoreleasing NSArray  *components = [name componentsSeparatedByString:@"."];

        __autoreleasing NSString *modifiedName = (components.count == 2 ? [NSString stringWithFormat:@"%@-568h.%@", components[0], components[1]] : [NSString stringWithFormat:@"%@-568h", components[0]]);
        return [UIImage imageNamed:modifiedName];
    }
    else {
        return [UIImage imageNamed:name];
    }
}

+ (__autoreleasing UIImage *)reflectedImageWithView:(UIView *)view height:(NSUInteger)height {
    if(!view || height == 0) return nil;
    
    // create a bitmap graphics context the size of the image
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef mainContext = CGBitmapContextCreate (nil, view.bounds.size.width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    FwiReleaseCF(colorSpace);
	
	// Create a 1 pixel wide gradient
    colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef gradientContext = CGBitmapContextCreate(nil, view.bounds.size.width, height, 8, 0, colorSpace, (kCGBitmapAlphaInfoMask & kCGImageAlphaNone));
    
	// Create the CGGradient
    CGFloat colors[] = { 0.0f, 1.0f, 1.0f, 1.0f };
	CGGradientRef grayscaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, nil, 2);
    FwiReleaseCF(colorSpace);
	
	// Draw the gradient into the gray bitmap context
	CGPoint gradientStart = CGPointZero;
	CGPoint gradientEnd   = CGPointMake(0.0f, height);
	CGContextDrawLinearGradient(gradientContext, grayscaleGradient, gradientStart, gradientEnd, kCGGradientDrawsAfterEndLocation);
    FwiReleaseCF(grayscaleGradient);
	
	// Convert the context into a CGImageRef
	CGImageRef imgGradientRef = CGBitmapContextCreateImage(gradientContext);
	FwiReleaseCF(gradientContext);
    
	
	// Create an image by masking the bitmap
	CGContextClipToMask(mainContext, CGRectMake(0.0f, 0.0f, view.bounds.size.width, height), imgGradientRef);
	FwiReleaseCF(imgGradientRef);
	
	// In order to grab the part of the image that we want to render, we move the context origin  to
    // the height of the image
	CGContextTranslateCTM(mainContext, 0.0f, height);
	CGContextScaleCTM(mainContext, 1.0f, -1.0f);
	
	// Draw the image into the bitmap context
	CGContextDrawImage(mainContext, view.bounds, [[view createImage] CGImage]);
	
	// Create CGImageRef
	CGImageRef imgReflectedRef = CGBitmapContextCreateImage(mainContext);
	FwiReleaseCF(mainContext);
	
	// Convert to UIImage
	__autoreleasing UIImage *imgReflected = [UIImage imageWithCGImage:imgReflectedRef];
	FwiReleaseCF(imgReflectedRef);
	return imgReflected;
}


@end


@implementation UIImage (FwiExtension)


- (__autoreleasing UIImage *)darkBlur {
    return [self darkBlurWithRadius:20.0f saturationFactor:1.9f];
}
- (__autoreleasing UIImage *)darkBlurWithRadius:(CGFloat)radius saturationFactor:(CGFloat)saturationFactor {
    __autoreleasing UIColor *tintColor = [UIColor colorWithWhite:0.1f alpha:0.5f];
    return [self blurWithRadius:radius tintColor:tintColor saturationFactor:saturationFactor];
}

- (__autoreleasing UIImage *)lightBlur {
    return [self lightBlurWithRadius:20.0f saturationFactor:1.9f];
}
- (__autoreleasing UIImage *)lightBlurWithRadius:(CGFloat)radius saturationFactor:(CGFloat)saturationFactor {
    __autoreleasing UIColor *tintColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    return [self blurWithRadius:radius tintColor:tintColor saturationFactor:saturationFactor];
}


#pragma mark - Class's private methods
- (__autoreleasing UIImage *)blurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationFactor:(CGFloat)saturationFactor {
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    __autoreleasing UIImage *effectImage = self;
    
    /* Condition validation: Validate against zero */
    BOOL hasBlur = (blurRadius > __FLT_EPSILON__);
    BOOL hasSaturation = (fabs(saturationFactor - 1.0f) > __FLT_EPSILON__);
    
    if (hasBlur || hasSaturation) {
        /** Effect Input Context */
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0f);
        CGContextRef inputContext = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(inputContext, 1.0f, -1.0f);
        CGContextTranslateCTM(inputContext, 0.0f, -self.size.height);
        
        // Draw this image on effect input context
        CGContextDrawImage(inputContext, imageRect, self.CGImage);
        
        // Capture image from input context to input buffer
        vImage_Buffer inputBuffer;
        inputBuffer.data     = CGBitmapContextGetData(inputContext);
        inputBuffer.width    = CGBitmapContextGetWidth(inputContext);
        inputBuffer.height   = CGBitmapContextGetHeight(inputContext);
        inputBuffer.rowBytes = CGBitmapContextGetBytesPerRow(inputContext);
        
        
        /** Effect Output Context */
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0f);
        CGContextRef outputContext = UIGraphicsGetCurrentContext();
        
        // Prepare output buffer
        vImage_Buffer outputBuffer;
        outputBuffer.data     = CGBitmapContextGetData(outputContext);
        outputBuffer.width    = CGBitmapContextGetWidth(outputContext);
        outputBuffer.height   = CGBitmapContextGetHeight(outputContext);
        outputBuffer.rowBytes = CGBitmapContextGetBytesPerRow(outputContext);
        
        // Apply blur if required
        if (hasBlur) {
            uint32_t radius = floor(blurRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            
            /* Condition validation: Three box-blur methodology require odd radius */
            if (radius % 2 != 1) radius += 1;
            
            vImageBoxConvolve_ARGB8888(&inputBuffer , &outputBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&outputBuffer, &inputBuffer , NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&inputBuffer , &outputBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        
        BOOL isSwapped = NO;
        if (hasSaturation) {
            CGFloat s = saturationFactor;
            CGFloat saturationMatrixf[] = {
                0.0722f + 0.9278f * s,  0.0722f - 0.0722f * s,  0.0722f - 0.0722f * s,  0,
                0.7152f - 0.7152f * s,  0.7152f + 0.2848f * s,  0.7152f - 0.7152f * s,  0,
                0.2126f - 0.2126f * s,  0.2126f - 0.2126f * s,  0.2126f + 0.7873f * s,  0,
                0,                      0,                      0,  1,
            };
            
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(saturationMatrixf) / sizeof(saturationMatrixf[0]);
            
            // Convert saturation matrix from float to 8Bits value
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(saturationMatrixf[i] * divisor);
            }
            
            // Apply blur effect
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&outputBuffer, &inputBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                isSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&inputBuffer, &outputBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        
        if (!isSwapped) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (isSwapped) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(outputContext, 1.0f, -1.0f);
    CGContextTranslateCTM(outputContext, 0.0f, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw blur image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        
        CGContextRestoreGState(outputContext);
    }
    
    // Add tint color
    if (tintColor) {
        CGContextSaveGState(outputContext);
        
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        
        CGContextRestoreGState(outputContext);
    }
    
    // Output result
    __autoreleasing UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}


@end
