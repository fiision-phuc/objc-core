#import "NSString+FwiExtension.h"


@implementation NSString (FwiCreation)


+ (__autoreleasing NSString *)randomIdentifier {
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    __autoreleasing NSString *uuid = (__bridge_transfer NSString *) CFBridgingRelease(CFUUIDCreateString(nil, uuidRef));
    
    FwiReleaseCF(uuidRef);
    
    return uuid;
}

+ (__autoreleasing NSString *)timestamp {
    __autoreleasing NSString *timestamp = [[NSString alloc] initWithFormat:@"%ld", time(NULL)];
    
    return FwiAutoRelease(timestamp);
}


@end


@implementation NSString (FwiExtension)


- (BOOL)isEqualToStringIgnoreCase:(NSString *)otherString {
    /* Condition validation */
    if (!self || !otherString) {
        return NO;
    }
    
    __autoreleasing NSString *text1 = (otherString.lowercaseString).trim;
    __autoreleasing NSString *text2 = (self.lowercaseString).trim;
    
    return [text1 isEqualToString:text2];
}

- (BOOL)matchPattern:(NSString *)pattern {
    /* Condition validation */
    if (!self || self.length == 0 || !pattern || pattern.length == 0) {
        return NO;
    }
    
    return [self matchPattern:pattern option:NSRegularExpressionCaseInsensitive];
}
- (BOOL)matchPattern:(NSString *)pattern option:(NSRegularExpressionOptions)option {
    /* Condition validation */
    if (!self || self.length == 0 || !pattern || pattern.length == 0) {
        return NO;
    }
    
    __autoreleasing NSError *error = nil;
    __autoreleasing NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:option error:&error];
    
    NSUInteger matches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return matches == 1;
}

- (__autoreleasing NSData *)toData {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return [self toDataWithEncoding:NSUTF8StringEncoding];
}
- (__autoreleasing NSData *)toDataWithEncoding:(NSStringEncoding)encoding {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    return [self dataUsingEncoding:encoding];
}

- (__autoreleasing NSString *)decodeHTML {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    __autoreleasing NSString *result = (__bridge_transfer NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef) self, CFSTR(""), kCFStringEncodingUTF8));
    
    return result;
}
- (__autoreleasing NSString *)encodeHTML {
    /* Condition validation */
    if (!self || self.length <= 0) {
        return nil;
    }
    
    __autoreleasing NSString *result = (__bridge_transfer NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) self, nil, CFSTR(":/=,!$&'()*+;[]@#?"), kCFStringEncodingUTF8));
    
    return result;
}
- (__autoreleasing NSString *)trim {
    /* Condition validation */
    if (!self) {
        return nil;
    }
    
    /* Condition validation: return empty string if it is empty */
    if (self.length <= 0) {
        return @"";
    }
    
    __autoreleasing NSString *text = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return text;
}


@end
