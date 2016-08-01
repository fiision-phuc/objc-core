#import "UISplitViewController+FwiExtension.h"


@implementation UISplitViewController (FwiExtension)


- (BOOL)prefersStatusBarHidden {
    //    if (self.topViewController) {
    //        return [self.topViewController prefersStatusBarHidden];
    //    }
    DLog(@"%@", self.viewControllers);
    
    return [super prefersStatusBarHidden];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    //    if (self.topViewController) {
    //        return [self.topViewController preferredStatusBarStyle];
    //    }
    DLog(@"%@", self.viewControllers);
    
    return [super preferredStatusBarStyle];
}

- (BOOL)shouldAutorotate {
    //    return self.visibleViewController.shouldAutorotate;
    DLog(@"%@", self.viewControllers);
    
    return NO;
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return self.visibleViewController.supportedInterfaceOrientations;
//}
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [self.visibleViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self.visibleViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//}


@end
