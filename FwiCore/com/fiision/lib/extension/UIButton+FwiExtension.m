#import "UIButton+FwiExtension.h"


@implementation UIButton (FwiExtension)


- (void)applyBackgroundImage:(NSString *)imageName withEdgeInsets:(UIEdgeInsets)edgeInsets {
    __autoreleasing UIImage *imageDefault = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_Default", imageName]] resizableImageWithCapInsets:edgeInsets];
    __autoreleasing UIImage *imageHighlighted = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_Highlighted", imageName]] resizableImageWithCapInsets:edgeInsets];
    __autoreleasing UIImage *imageSelected = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected", imageName]] resizableImageWithCapInsets:edgeInsets];
    __autoreleasing UIImage *imageDisabled = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_Disabled", imageName]] resizableImageWithCapInsets:edgeInsets];
    
    [self setBackgroundImage:imageDefault forState:UIControlStateNormal];
    [self setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
    [self setBackgroundImage:imageSelected forState:UIControlStateSelected];
    [self setBackgroundImage:imageDisabled forState:UIControlStateDisabled];
}

- (void)applyImage:(NSString *)imageName {
    __autoreleasing UIImage *imageDefault = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Default", imageName]];
    __autoreleasing UIImage *imageHighlighted = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Highlighted", imageName]];
    __autoreleasing UIImage *imageSelected = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected", imageName]];
    __autoreleasing UIImage *imageDisabled = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Disabled", imageName]];
    
    [self setImage:imageDefault forState:UIControlStateNormal];
    [self setImage:imageHighlighted forState:UIControlStateHighlighted];
    [self setImage:imageSelected forState:UIControlStateSelected];
    [self setImage:imageDisabled forState:UIControlStateDisabled];
}


@end
