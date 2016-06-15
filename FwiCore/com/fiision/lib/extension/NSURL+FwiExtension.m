#import "NSURL+FwiExtension.h"


@implementation NSURL (FwiCreation)


+ (__autoreleasing NSURL *)cacheDirectory {
    __autoreleasing NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    __autoreleasing NSURL *directory = array.lastObject;
    return directory;
}

+ (__autoreleasing NSURL *)documentDirectory {
    __autoreleasing NSArray *array = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    __autoreleasing NSURL *directory = array.lastObject;
    return directory;
}


@end
