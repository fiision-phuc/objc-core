#import "NSString+FwiBase64.h"
#import "FwiCore.h"


@implementation NSString (FwiBase64)


#pragma mark - Validate base64
- (BOOL)isBase64 {
    /* Condition validation */
	if (!self || [self length] <= 0) return NO;
    return [[[self trim] toData] isBase64];
}


#pragma mark - Decode base64
- (__autoreleasing NSData *)decodeBase64Data {
    /* Condition validation */
	if (!self || [self length] <= 0) return nil;
    return [[self toData] decodeBase64Data];
}
- (__autoreleasing NSString *)decodeBase64String {
	/* Condition validation */
	if (!self || [self length] <= 0) return nil;
	return [[self toData] decodeBase64String];
}


#pragma mark - Encode base64
- (__autoreleasing NSData *)encodeBase64Data {
    /* Condition validation */
	if (!self || [self length] <= 0) return nil;
    return [[self toData] encodeBase64Data];
}
- (__autoreleasing NSString *)encodeBase64String {
	/* Condition validation */
	if (!self || [self length] <= 0) return nil;
	return [[self toData] encodeBase64String];
}


@end
