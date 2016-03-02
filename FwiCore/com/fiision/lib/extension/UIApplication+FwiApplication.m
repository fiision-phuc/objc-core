#import "UIApplication+FwiApplication.h"


@implementation UIApplication (FwiApplication)


- (void)enableRemoteNotification {
#if !TARGET_IPHONE_SIMULATOR
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 8) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    else {
        __autoreleasing UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
#endif
}


@end
