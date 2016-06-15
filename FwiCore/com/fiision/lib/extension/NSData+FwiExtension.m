#import "NSData+FwiExtension.h"


#define CHUNK_SIZE  16384


@implementation NSData (FwiExtension)


- (__autoreleasing NSData *)zip {
    /* Condition validation */
	if (!self || self.length <= 0) return nil;
    
    z_stream stream;
    stream.zalloc    = Z_NULL;
    stream.zfree     = Z_NULL;
    stream.opaque    = Z_NULL;
    stream.avail_in  = (uint)self.length;
    stream.next_in   = (Bytef *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    __autoreleasing NSMutableData *data = nil;
    if (deflateInit2(&stream, Z_BEST_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        data = [NSMutableData dataWithLength:CHUNK_SIZE];
        
        while (stream.avail_out == 0) {
            if (stream.total_out >= data.length) {
                data.length += CHUNK_SIZE;
            }
            
            stream.next_out  = data.mutableBytes + stream.total_out;
            stream.avail_out = (uint)(data.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        data.length = stream.total_out;
    }
    return data;
}
- (__autoreleasing NSData *)unzip {
    /* Condition validation */
	if (!self || self.length <= 0) return nil;

    z_stream stream;
    stream.zalloc    = Z_NULL;
    stream.zfree     = Z_NULL;
    stream.avail_in  = (uint)self.length;
    stream.next_in   = (Bytef *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    __autoreleasing NSMutableData *data = nil;
    if (inflateInit2(&stream, 47) == Z_OK) {
        data = [NSMutableData dataWithLength:self.length * 1.5];
        
        // Inflate data
        int status = Z_OK;
        while (status == Z_OK) {
            if (stream.total_out >= data.length) {
                data.length += self.length * 0.5;
            }
            
            stream.next_out  = data.mutableBytes + stream.total_out;
            stream.avail_out = (uint)(data.length - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }
        
        // Finalize data
        if (inflateEnd(&stream) == Z_OK && status == Z_STREAM_END) {
            data.length = stream.total_out;
        }
        else {
            data = nil;
        }
    }
    return data;
}

- (__autoreleasing NSString *)toString {
    /* Condition validation */
	if (!self || self.length <= 0) return nil;
    return [self toStringWithEncoding:NSUTF8StringEncoding];
}
- (__autoreleasing NSString *)toStringWithEncoding:(NSStringEncoding)encoding {
    /* Condition validation */
	if (!self || self.length <= 0) return nil;
    
    __autoreleasing NSString *text = FwiAutoRelease([[NSString alloc] initWithBytes:[self bytes] length:[self length] encoding:encoding]);
	return text;
}

- (void)clearBytes {
    /* Condition validation */
	if (!self || self.length <= 0) return;
    
    uint8_t *bytes = (void *)self.bytes;
    bzero(bytes, self.length);
}
- (void)reverseBytes {
	/* Condition validation */
	if (!self || self.length <= 0) return;
	uint8_t *bytes = (void *)self.bytes;
	
    uint8_t temp = 0x00;
    NSUInteger end  = self.length - 1;
    NSUInteger step = self.length / 2;
    for (NSUInteger i = 0; i < step; i++, end--) {
        temp = bytes[i];
        
        bytes[i] = bytes[end];
        bytes[end] = temp;
    }
}


@end
