#import "FwiCacheFolder.h"


@interface FwiCacheFolder () {
    
    __weak NSFileManager *_fileManager;
}


/** Validate filename. */
- (NSString *)_validateFilename:(NSString *)filename;

/** Delete all expired files. */
- (void)_clearFolder;
/** Delete all files at specific path. */
- (void)_clearAllFilesAtPath:(NSString *)path;

@end


@implementation FwiCacheFolder


@synthesize pathReady=_pathReady;


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        _pathReady   = nil;
        _idleTime    = 172800;                                                                      // 2 days = 2 * 24 * 60 * 60
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}


#pragma mark - Cleanup memory
-(void)dealloc {
    FwiRelease(_pathReady);

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (__autoreleasing NSString *)pathForReadyFile:(NSString *)filename {
    /* Condition validation */
    if (!filename || filename.length == 0) return nil;
    
    filename = [self _validateFilename:filename];
	return [NSString stringWithFormat:@"%@%@", _pathReady, filename];
}

- (__autoreleasing NSString *)loadingFinishedForFilename:(NSString *)filename {
    /* Condition validation */
    if (!filename || filename.length == 0) return nil;
	__autoreleasing NSString *readyFile = [self pathForReadyFile:filename];
    
//    // Move file to ready folder
//	__autoreleasing NSError *error = nil;
//	[_manager moveItemAtPath:loadingFile toPath:readyFile error:&error];
    
//    // Apply exclude backup attribute
//    __autoreleasing NSURL *readyURL = [NSURL fileURLWithPath:readyFile];
//    [readyURL setResourceValues:@{NSURLIsExcludedFromBackupKey:@YES} error:&error];
//    
//    // Destroy file if it could not exclude from backup
//    if (error) [_manager removeItemAtPath:readyFile error:nil];
//    return (!error ? readyFile : nil);
}

- (void)updateFile:(NSString *)filename {
    /* Condition validation */
	__autoreleasing NSDictionary *attributes = [_fileManager attributesOfItemAtPath:filename error:nil];
    if (!attributes) return;
    
    /* Condition validation: */
    NSTimeInterval seconds = -1 * [[attributes objectForKey:NSFileModificationDate] timeIntervalSinceNow];
    if (seconds < (_idleTime / 2)) return;
    
    __autoreleasing NSMutableDictionary *newAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [newAttributes setObject:[NSDate date] forKey:NSFileModificationDate];
    [_fileManager setAttributes:newAttributes ofItemAtPath:filename error:nil];
}
- (void)clearCache {
	[self _clearAllFilesAtPath:_pathReady];
}


#pragma mark - Class's private methods
- (NSString *)_validateFilename:(NSString *)filename {
    __autoreleasing NSData *data = [filename toData];
    uint8_t *chars = (void *)[data bytes];
    
    // Replace all invalid characters
    for (NSUInteger i = 0; i < data.length; i++) {
        if (chars[i] == ':' || chars[i] == '/') chars[i] = '_';
    }
    filename = [data toString];
	return filename;
}

- (void)_clearFolder {
    __autoreleasing NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:_pathReady];
    __autoreleasing NSString *filename = [enumerator nextObject];
    
    while (filename) {
        filename = [NSString stringWithFormat:@"%@%@", _pathReady, filename];
        
        // Load file's attributes
        NSDictionary *attributes = [_fileManager attributesOfItemAtPath:filename error:nil];
        NSTimeInterval seconds = -1 * [[attributes fileModificationDate] timeIntervalSinceNow];
        
        if (seconds >= _idleTime) {
            [_fileManager removeItemAtPath:filename error:nil];
        }
        filename = [enumerator nextObject];
    }
}
- (void)_clearAllFilesAtPath:(NSString *)path {
	__autoreleasing NSError *error = nil;
    
    /* Condition validation: Validate path */
	__autoreleasing NSArray *files = [_fileManager contentsOfDirectoryAtPath:path error:&error];
	if (error != nil) return;
    
    // Delete files
	for (NSString *file in files) {
		__autoreleasing NSString *filepath = [NSString stringWithFormat:@"%@%@", path, file];
		[_fileManager removeItemAtPath:filepath error:&error];
	}
}


@end


@implementation FwiCacheFolder (FwiCacheCreation)


#pragma mark - Class's static constructors
+ (__autoreleasing FwiCacheFolder *)cacheFolderWithNamed:(NSString *)named {
    return FwiAutoRelease([[FwiCacheFolder alloc] initWithNamed:named]);
}


#pragma mark - Class's constructors
- (id)initWithNamed:(NSString *)named {
	self = [self init];
    if (self) {
        _pathReady = [[NSString alloc] initWithFormat:@"%@/%@/", [[NSURL cacheDirectory] path], named];
        
        /* Condition validation: Validate paths */
        BOOL isFolder  = NO;
        BOOL isExisted = [_fileManager fileExistsAtPath:_pathReady isDirectory:&isFolder];
        
        if (isExisted && isFolder) {
            // Do nothing
        }
        else if (isExisted && !isFolder) {
            [_fileManager removeItemAtPath:_pathReady error:nil];
            [_fileManager createDirectoryAtPath:_pathReady withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else {
            [_fileManager createDirectoryAtPath:_pathReady withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //delete any half loaded files
        [self _clearFolder];
	}
	return self;
}


@end
