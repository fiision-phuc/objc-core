#import "UIColor+FwiExtension.h"


@implementation UIColor (FwiCreation)


+ (__autoreleasing UIColor *)colorWithRGB:(NSUInteger)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0f
                           green:((float)((rgb & 0xFF00) >> 8))/255.0f
                            blue:((float)(rgb & 0xFF))/255.0f
                           alpha:1.0f];

}
+ (__autoreleasing UIColor *)colorWithRGBA:(NSUInteger)rgba {
    return [UIColor colorWithRed:((float)((rgba & 0xFF000000) >> 24))/255.0f
                           green:((float)((rgba & 0x00FF0000) >> 16))/255.0f
                            blue:((float)((rgba & 0x0000FF00) >> 8))/255.0f
                           alpha:((float)(rgba & 0x000000FF))/255.0f];

}


@end
