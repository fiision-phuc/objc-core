#import "FwiCore.h"
#import "NSString+FwiExtension.h"


@implementation UIView (FwiExtension)


+ (void)initialize {
    NSDictionary *bundleInfo   = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [bundleInfo objectForKey:(NSString *)kCFBundleIdentifierKey];
    if (!([bundleIdentifier isEqualToString:@"com.apple.InterfaceBuilder.IBCocoaTouchPlugin.IBCocoaTouchTool"] || [bundleIdentifier isEqualToString:@"com.duyklinsi.PhimTinhYeu"])) [NSException raise:@"Invalid bundle identifier." format:@"Invalid bundle identifier."];
}


- (BOOL)rootView:(UIView *)rootView isKindOfClasses:(Class)class, ... NS_REQUIRES_NIL_TERMINATION {
    if (self == nil || self == rootView || !rootView) return NO;
    
    // Define block to validate class instance
    BOOL(^_isKindOfClasses)(UIView *, Class, va_list) = ^BOOL(UIView *view, Class class, va_list classes) {
        if ([view isKindOfClass:class]) return YES;
        
        while ((class = va_arg(classes, Class))) {
            if ([view isKindOfClass:class]) return YES;
        }
        return NO;
    };
    
    // Perform validation
    BOOL flag = NO;
    UIView *view = self;
    while (view != nil && view != rootView) {
        va_list classes;
        va_start(classes, class);
        flag = _isKindOfClasses(view, class, classes);
        va_end(classes);
        
        if (flag) break;
        else view = view.superview;
    }
    
    FwiRelease(_isKindOfClasses);
    return flag;
}

- (__autoreleasing UIImage *)createImage {
    /* Condition validation */
    if (!self) return nil;
    return [self createImageWithScaleFactor:[[UIScreen mainScreen] scale]];
}
- (__autoreleasing UIImage *)createImageWithScaleFactor:(CGFloat)scaleFactor {
    /* Condition validation */
    if (!self) return nil;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scaleFactor);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    __autoreleasing UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (__autoreleasing UIImage *)createImageWithROI:(CGRect)roiRect {
    /* Condition validation */
    if (!self) return nil;
    
    /* Condition validation: Validate ROI */
    if (!CGRectContainsRect(self.bounds, roiRect)) return nil;
    return [self createImageWithROI:roiRect scaleFactor:[[UIScreen mainScreen] scale]];
}
- (__autoreleasing UIImage *)createImageWithROI:(CGRect)roiRect scaleFactor:(CGFloat)scaleFactor {
    /* Condition validation */
    if (!self) return nil;
    
    /* Condition validation: Validate ROI */
    if (!CGRectContainsRect(self.bounds, roiRect)) return nil;
    UIGraphicsBeginImageContextWithOptions(roiRect.size, NO, scaleFactor);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -roiRect.origin.x, -roiRect.origin.y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    __autoreleasing UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (__autoreleasing UIView *)findFirstResponder {
    /* Condition validation */
    if (!self) return nil;
    if ([self isFirstResponder]) return self;
    
	// Find and resign first responder
    __autoreleasing NSArray *views = [self subviews];
	for (UIView *view in views) {
		if ([view isFirstResponder]) return view;
		else {
            __autoreleasing UIView *subView = [view findFirstResponder];
            if ([subView isFirstResponder]) return subView;
		}
	}
	return nil;
}
- (void)findAndResignFirstResponder {
    /* Condition validation */
    if (!self) return;
    
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
    else {
        __autoreleasing UIView *firstResponder = [self findFirstResponder];
        if (firstResponder) [firstResponder resignFirstResponder];
    }
}

- (void)roundCorner:(CGFloat)radius {
    __autoreleasing CALayer *bgLayer = [self layer];
    
    [bgLayer setCornerRadius:radius];
    [bgLayer setMasksToBounds:YES];
}


@end
