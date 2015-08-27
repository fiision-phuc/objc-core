#import "UINavigationController+FwiExtension.h"


@implementation UINavigationController (FwiExtension)


- (BOOL)shouldAutorotate {
    return self.visibleViewController.shouldAutorotate;
}
- (NSUInteger)supportedInterfaceOrientations {
    return self.visibleViewController.supportedInterfaceOrientations;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.visibleViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.visibleViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


@end
