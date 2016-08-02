#import "NSString+FwiHex.h"


@implementation NSString (FwiHex)


#pragma mark - Validate Hex
- (BOOL)isHex {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return NO;
    }
    
    return self.trim.toData.hex;
}


#pragma mark - Decode Hex
- (__autoreleasing NSData *)decodeHexData {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return self.toData.decodeHexData;
}
- (__autoreleasing NSString *)decodeHexString {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return self.toData.decodeHexString;
}


#pragma mark - Encode Hex
- (__autoreleasing NSData *)encodeHexData {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return self.toData.encodeHexData;
}
- (__autoreleasing NSString *)encodeHexString {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return self.toData.encodeHexString;
}


@end
