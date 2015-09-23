#import "UITabBarController+FwiExtension.h"


@implementation UITabBarController (FwiExtension)


- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}
//- (NSUInteger)supportedInterfaceOrientations {
//    return self.visibleViewController.supportedInterfaceOrientations;
//}
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [self.visibleViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self.visibleViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//}


@end
