#import "NSDictionary+FwiExtension.h"


@implementation NSDictionary (FwiCreation)


+ (__autoreleasing NSDictionary *)loadPlist:(NSString *)plistname {
    /* Condition validation */
    if (!plistname || plistname.length == 0) return nil;
    return [NSDictionary loadPlist:plistname bundle:[NSBundle mainBundle]];
}
+ (__autoreleasing NSDictionary *)loadPlist:(NSString *)plistname bundle:(NSBundle *)bundle {
    /* Condition validation */
    if (!plistname || plistname.length == 0) return nil;
    if (!bundle) bundle = [NSBundle mainBundle];
    
    __autoreleasing NSString *path = [bundle pathForResource:plistname ofType:@"plist"];
    return FwiAutoRelease([[NSDictionary alloc] initWithContentsOfFile:path]);
}


@end


@implementation NSDictionary (FwiExtension)


- (__autoreleasing id)objectWithPath:(NSString *)path {
    /* Condition validation */
    if (!self || [self count] == 0) return nil;
    
    __autoreleasing NSArray *tokens = [path componentsSeparatedByString:@"/"];
    _weak id o = self;
    
    for (NSUInteger i = 0; i < [tokens count]; i++) {
        _weak NSString *path = tokens[i];
        
        // Lookup object
        if ([o isKindOfClass:[NSArray class]]) {
            NSInteger index = [path integerValue];
            if (index < 0 || index >= [(NSArray *)o count]) {
                o = nil;
            }
            else {
                o = ((NSArray *)o)[index];
            }
        }
        else if ([o isKindOfClass:[NSDictionary class]]) {
			o = ((NSDictionary *)o)[path];
        }
		else {
            o = nil;
		}
        
        // Break
        if (o == nil) break;
    }
	return o;
}

- (__autoreleasing NSDictionary *)toDictionary {
    /* Condition validation */
    if (!self) return nil;
    
    __autoreleasing NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self];
    return dict;
}
- (__autoreleasing NSMutableDictionary *)toMutableDictionary {
    /* Condition validation */
    if (!self) return nil;
    
    __autoreleasing NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
    return dict;
}


@end
