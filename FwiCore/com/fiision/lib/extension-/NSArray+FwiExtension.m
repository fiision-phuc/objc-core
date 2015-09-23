#import "NSArray+FwiExtension.h"


@implementation NSArray (FwiExtension)


- (__autoreleasing id)objectWithPath:(NSString *)path {
    /* Condition validation */
    if (!self || self.count == 0) return nil;
    
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

- (__autoreleasing NSArray *)toArray {
    /* Condition validation */
    if (!self || self.count == 0) return nil;
    
    __autoreleasing NSArray *array = [NSArray arrayWithArray:self];
    return array;
}
- (__autoreleasing NSMutableArray *)toMutableArray {
    /* Condition validation */
    if (!self || self.count == 0) return nil;
    
    __autoreleasing NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    return array;
}


@end
