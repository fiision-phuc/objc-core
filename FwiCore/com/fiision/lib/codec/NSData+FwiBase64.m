#import "NSData+FwiBase64.h"
#import "FwiCore.h"


@implementation NSData (FwiBase64)


static const uint8_t _EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b',
    'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/'
};

static const uint8_t _DecodingTable[128] = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x3e, 0x00, 0x00, 0x00, 0x3f, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b,
    0x3c, 0x3d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04,
    0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12,
    0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1a,
    0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
    0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x00, 0x00, 0x00,
    0x00, 0x00
};


#pragma mark - Validate base64
- (BOOL)isBase64 {
    /* Condition validation */
    if (!self || self.length <= 0 || (self.length % 4) != 0) {
        return NO;
    }
    const uint8_t *bytes = self.bytes;
    BOOL isBase64 = YES;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        uint8_t octet = bytes[i];
        
        isBase64 &= (octet == '=' || octet < sizeof(_DecodingTable));
        if (!isBase64) {
            break;
        }
    }
    
    return isBase64;
}


#pragma mark - Decode base64
- (__autoreleasing NSData *)decodeBase64Data {
    /* Condition validation */
    if (!self || !self.base64) {
        return nil;
    }
    
    // Initialize buffer
    uint8_t b1, b2, b3, b4;
    const uint8_t *bytes = self.bytes;
    
    // Calculate output length
    NSUInteger end = self.length;
    NSUInteger finish = end - 4;
    NSUInteger length = (finish >> 2) * 3;
    if (bytes[end - 2] == '=') {
        length += 1;
    }
    else if (bytes[end - 1] == '=') {
        length += 2;
    }
    else {
        length += 3;
    }
    
    // Create output buffer
    uint8_t *outputBytes = malloc(length);
    bzero(outputBytes, length);
    
    // Decoding process
    NSUInteger index = -1;
    for (NSUInteger i = 0; i < finish; i += 4) {
        b1 = _DecodingTable[bytes[i]];
        b2 = _DecodingTable[bytes[i + 1]];
        b3 = _DecodingTable[bytes[i + 2]];
        b4 = _DecodingTable[bytes[i + 3]];
        
        outputBytes[++index] = (b1 << 2) | (b2 >> 4);
        outputBytes[++index] = (b2 << 4) | (b3 >> 2);
        outputBytes[++index] = (b3 << 6) | b4;
    }
    
    // Decoding last block process
    if (bytes[end - 2] == '=') {
        b1 = _DecodingTable[bytes[end - 4]];
        b2 = _DecodingTable[bytes[end - 3]];
        
        outputBytes[++index] = (b1 << 2) | (b2 >> 4);
    }
    else if (bytes[end - 1] == '=') {
        b1 = _DecodingTable[bytes[end - 4]];
        b2 = _DecodingTable[bytes[end - 3]];
        b3 = _DecodingTable[bytes[end - 2]];
        
        outputBytes[++index] = (b1 << 2) | (b2 >> 4);
        outputBytes[++index] = (b2 << 4) | (b3 >> 2);
    }
    else {
        b1 = _DecodingTable[bytes[end - 4]];
        b2 = _DecodingTable[bytes[end - 3]];
        b3 = _DecodingTable[bytes[end - 2]];
        b4 = _DecodingTable[bytes[end - 1]];
        
        outputBytes[++index] = (b1 << 2) | (b2 >> 4);
        outputBytes[++index] = (b2 << 4) | (b3 >> 2);
        outputBytes[++index] = (b3 << 6) | b4;
    }
    
    __autoreleasing NSData *data = [NSData dataWithBytes:outputBytes length:length];
    free(outputBytes);
    
    return data;
}
- (__autoreleasing NSString *)decodeBase64String {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return [self.decodeBase64Data toString];
}


#pragma mark - Encode base64
- (__autoreleasing NSData *)encodeBase64Data {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    // Calculate output length
    uint8_t modulus = self.length % 3;
    NSUInteger dataLength = self.length - modulus;
    NSUInteger outputLength = (dataLength / 3) * 4 + ((modulus == 0) ? 0 : 4);
    
    // Create output space
    const uint8_t *bytes = self.bytes;
    uint8_t *outputBytes = malloc(outputLength);
    bzero(outputBytes, outputLength);
    
    // Encoding process
    NSUInteger index = -1;
    uint8_t a1, a2, a3;
    for (NSUInteger i = 0; i < dataLength; i += 3) {
        a1 = bytes[i];
        a2 = bytes[i + 1];
        a3 = bytes[i + 2];
        
        outputBytes[++index] = _EncodingTable[(a1 >> 2) & 0x3f];
        outputBytes[++index] = _EncodingTable[((a1 << 4) | (a2 >> 4)) & 0x3f];
        outputBytes[++index] = _EncodingTable[((a2 << 2) | (a3 >> 6)) & 0x3f];
        outputBytes[++index] = _EncodingTable[a3 & 0x3f];
    }
    
    // Process the tail end
    uint8_t b1, b2, b3;
    uint8_t d1, d2;
    switch (modulus) {
        case 1: {
            d1 = bytes[dataLength];
            b1 = (d1 >> 2) & 0x3f;
            b2 = (d1 << 4) & 0x3f;
            
            outputBytes[++index] = _EncodingTable[b1];
            outputBytes[++index] = _EncodingTable[b2];
            outputBytes[++index] = '=';
            outputBytes[++index] = '=';
            break;
        }
            
        case 2: {
            d1 = bytes[dataLength];
            d2 = bytes[dataLength + 1];
            
            b1 = (d1 >> 2) & 0x3f;
            b2 = ((d1 << 4) | (d2 >> 4)) & 0x3f;
            b3 = (d2 << 2) & 0x3f;
            
            outputBytes[++index] = _EncodingTable[b1];
            outputBytes[++index] = _EncodingTable[b2];
            outputBytes[++index] = _EncodingTable[b3];
            outputBytes[++index] = '=';
            break;
        }
            
        default:
            break;
    }
    
    __autoreleasing NSData *data = [NSData dataWithBytes:outputBytes length:outputLength];
    free(outputBytes);
    
    return data;
}
- (__autoreleasing NSString *)encodeBase64String {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return [self.encodeBase64Data toString];
}


@end
