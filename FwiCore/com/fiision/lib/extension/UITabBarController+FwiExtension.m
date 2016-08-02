#import "UITabBarController+FwiExtension.h"


@implementation UITabBarController (FwiExtension)


- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}


@end
