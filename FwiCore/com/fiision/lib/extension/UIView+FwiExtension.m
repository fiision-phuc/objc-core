#import "NSString+FwiExtension.h"
#import "FwiCore.h"


@implementation UIView (FwiExtension)


- (__autoreleasing UIImage *)createImage {
    /* Condition validation */
    if (!self) return nil;
    return [self createImageWithScaleFactor:[[UIScreen mainScreen] scale]];
}
- (__autoreleasing UIImage *)createImageWithScaleFactor:(CGFloat)scaleFactor {
    /* Condition validation */
    if (!self) return nil;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scaleFactor);

    // Translate graphic context to offset before render if view is table view
    if ([self isKindOfClass:[UITableView class]]) {
        _weak UITableView *tableView = (UITableView *)self;
        CGPoint contentOffset = tableView.contentOffset;

        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), contentOffset.x, -contentOffset.y);
    }

    // Render view
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];

    // Create image
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
    if ([self isFirstResponder] && ![self isKindOfClass:[UITableViewCell class]] && ![self isKindOfClass:[UICollectionViewCell class]]) return self;
    
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
