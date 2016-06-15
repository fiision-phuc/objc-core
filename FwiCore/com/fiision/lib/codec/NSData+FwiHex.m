#import "NSData+FwiHex.h"


@implementation NSData (FwiHex)


static const uint8_t _HexEncodingTable[16] = {
    '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
};
static const uint8_t _HexDecodingTable[128] = {
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};


#pragma mark - Validate Hex
- (BOOL)isHex {
    /* Condition validation */
    if (!self || self.length == 0 || (self.length % 2) != 0) return NO;
    
    const uint8_t *bytes = self.bytes;
    BOOL isHexString = YES;
    
    for (size_t i = 0; i < self.length; i++) {
        uint8_t hex = bytes[i];
        
        isHexString &= (hex >= 0 && hex < sizeof(_HexDecodingTable));
        if (!isHexString) break;
    }
    return isHexString;
}


#pragma mark - Decode Hex
- (__autoreleasing NSData *)decodeHexData {
    /* Condition validation */
    if (!self || self.length == 0 || (self.length % 2) != 0) return nil;
    NSUInteger length = self.length >> 1;
    
    uint8_t *outputBytes = malloc(length);
    bzero(outputBytes, length);
    
    const uint8_t *chars = self.bytes;
    for (NSUInteger i = 0; i < self.length; i += 2) {
        uint8_t b1 = chars[i];
        uint8_t b2 = chars[i + 1];
        
        outputBytes[i / 2] = ((_HexDecodingTable[b1] << 4) | _HexDecodingTable[b2]);
    }
    
    __autoreleasing NSData *data = [NSData dataWithBytes:outputBytes length:length];
    free(outputBytes);
	return data;
}
- (__autoreleasing NSString *)decodeHexString {
    return [[self decodeHexData] toString];
}


#pragma mark - Encode Hex
- (__autoreleasing NSData *)encodeHexData {
    /* Condition validation */
    if (!self || self.length == 0) return nil;
    NSUInteger length = self.length << 1;
    
    uint8_t *outputBytes = malloc(length);
    bzero(outputBytes, length);
    
    const uint8_t *bytes = self.bytes;
    for (NSUInteger i = 0, j = 0; i < length; i += 2, j++) {
        uint8_t b = bytes[j];
        outputBytes[i] = _HexEncodingTable[(b >> 4)];
        outputBytes[i + 1] = _HexEncodingTable[(b & 0x0f)];
    }
    
    __autoreleasing NSData *data = [NSData dataWithBytes:outputBytes length:length];
    free(outputBytes);
	return data;
}
- (__autoreleasing NSString *)encodeHexString {
    return [[self encodeHexData] toString];
}


@end
