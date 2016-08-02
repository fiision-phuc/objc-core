#import "UINavigationController+FwiExtension.h"


@implementation UINavigationController (FwiExtension)


- (BOOL)prefersStatusBarHidden {
    if (self.visibleViewController) {
        return [self.visibleViewController prefersStatusBarHidden];
    }
    
    return [super prefersStatusBarHidden];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.visibleViewController) {
        return [self.visibleViewController preferredStatusBarStyle];
    }
    
    return [super preferredStatusBarStyle];
}

- (BOOL)shouldAutorotate {
    if (self.visibleViewController) {
        return [self.visibleViewController shouldAutorotate];
    }
    
    return [super shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.visibleViewController) {
        return [self.visibleViewController supportedInterfaceOrientations];
    }
    
    return [super supportedInterfaceOrientations];
}


@end
