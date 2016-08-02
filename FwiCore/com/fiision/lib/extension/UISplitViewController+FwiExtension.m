#import "UISplitViewController+FwiExtension.h"


@implementation UISplitViewController (FwiExtension)


- (BOOL)prefersStatusBarHidden {
    __autoreleasing NSArray *controllers = self.viewControllers;
    
    if (controllers.count > 0) {
        if ([UIApplication isPhone]) {
            return [[controllers firstObject] prefersStatusBarHidden];
        }
    }
    
    return [super prefersStatusBarHidden];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    __autoreleasing NSArray *controllers = self.viewControllers;
    
    if (controllers.count > 0) {
        if ([UIApplication isPhone]) {
            return [[controllers firstObject] preferredStatusBarStyle];
        }
    }
    
    return [super preferredStatusBarStyle];
}

- (BOOL)shouldAutorotate {
    __autoreleasing NSArray *controllers = self.viewControllers;
    
    if (controllers.count > 0) {
        if ([UIApplication isPhone]) {
            return [[controllers firstObject] shouldAutorotate];
        }
    }
    
    return [super shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    __autoreleasing NSArray *controllers = self.viewControllers;
    
    if (controllers.count > 0) {
        if ([UIApplication isPhone]) {
            return [[controllers firstObject] supportedInterfaceOrientations];
        }
    }
    
    return [super supportedInterfaceOrientations];
}


@end
