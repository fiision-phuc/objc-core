#import "UINavigationController+FwiExtension.h"


@implementation UINavigationController (FwiExtension)


- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return [self.topViewController prefersStatusBarHidden];
    }
    
    return [super prefersStatusBarHidden];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [self.topViewController preferredStatusBarStyle];
    }
    
    return [super preferredStatusBarStyle];
}

- (BOOL)shouldAutorotate {
    return self.visibleViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.visibleViewController.supportedInterfaceOrientations;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.visibleViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.visibleViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


@end
