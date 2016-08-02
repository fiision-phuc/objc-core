#import "UIApplication+FwiApplication.h"


@implementation UIApplication (FwiApplication)


+ (BOOL)isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isPhone {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (NSInteger)osVersion {
    __autoreleasing NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    __autoreleasing NSArray *tokens = [systemVersion componentsSeparatedByString:@"."];
    
    return [[tokens firstObject] integerValue];
}

+ (void)enableRemoteNotification {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Push notification does not support this device.");
#else
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
