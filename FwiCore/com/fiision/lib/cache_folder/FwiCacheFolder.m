#import "FwiCacheFolder.h"


@interface FwiCacheFolder () {
    
    NSFileManager *_fileManager;
    NSMutableArray *_placeHolder;
    FwiNetworkManager *_networkManager;
}


/** Validate filename. */
- (NSString *)_validateFilename:(NSString *)filename;

/** Delete all expired files. */
- (void)_clearFolder;
/** Delete all files at specific path. */
- (void)_clearAllFilesAtPath:(NSString *)path;

@end


@implementation FwiCacheFolder


@synthesize rootPath=_rootPath;


#pragma mark - Class's constructors
- (instancetype)init {
    self = [super init];
    if (self) {
        _rootPath       = nil;
        _idleTime       = 172800;                                                                   // 2 days = 2 * 24 * 60 * 60
        _fileManager    = [NSFileManager defaultManager];
        _networkManager = [FwiNetworkManager sharedInstance];
        
        _placeHolder = [[NSMutableArray alloc] initWithCapacity:50];
    }
    return self;
}


#pragma mark - Cleanup memory
-(void)dealloc {
    FwiRelease(_placeHolder);
    FwiRelease(_rootPath);
    _networkManager = nil;
    _fileManager = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (void)handleDelegate:(id<FwiCacheFolderDelegate>)delegate {
    NSURL *remoteURL = [delegate remoteMedia:self];
    NSString *readyFile = [self pathForRemoteMedia:remoteURL.description];
    
    if ([_fileManager fileExistsAtPath:readyFile]) {
        [self updateFile:readyFile];
        
        if (delegate && [delegate respondsToSelector:@selector(cacheFolder:didFinishDownloadingRemoteMedia:image:)]) {
            __autoreleasing UIImage *image = [UIImage imageWithContentsOfFile:readyFile];
            [delegate cacheFolder:self didFinishDownloadingRemoteMedia:remoteURL image:image];
        }
    }
    else {
        // Add to place holder
        @synchronized (_placeHolder) {
            [_placeHolder addObject:@{@"url":remoteURL, @"delegate":delegate}];
        }
        
        // Notify delegate before download
        if (delegate && [delegate respondsToSelector:@selector(cacheFolder:willDownloadRemoteMedia:)]) {
            [delegate cacheFolder:self willDownloadRemoteMedia:remoteURL];
        }
        
        // Perform download file from server
        __autoreleasing NSURLRequest *request = [_networkManager prepareRequestWithURL:remoteURL method:kGet];
        [_networkManager downloadResource:request completion:^(NSURL *location, __unused NSError *error, NSInteger statusCode, __unused NSHTTPURLResponse *response) {
            if (200 <= statusCode && statusCode <= 299) {
                __autoreleasing NSError *error = nil;
                [_fileManager moveItemAtPath:location.path toPath:readyFile error:&error];
            }
            
            // Notify all waiting delegates
            @synchronized (_placeHolder) {
                __autoreleasing NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF.url == %@", remoteURL];
                __autoreleasing NSArray *filters = [_placeHolder filteredArrayUsingPredicate:p];
                
                [filters enumerateObjectsUsingBlock:^(NSDictionary *item, __unused NSUInteger idx, __unused BOOL *stop) {
                    id<FwiCacheFolderDelegate> d = item[@"delegate"];
                    
                    if (d && [d respondsToSelector:@selector(cacheFolder:didFinishDownloadingRemoteMedia:image:)]) {
                        __autoreleasing UIImage *image = [UIImage imageWithContentsOfFile:readyFile];
                        [d cacheFolder:self didFinishDownloadingRemoteMedia:remoteURL image:image];
                    }
                }];
                
                // Update place holder
                [filters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *item, __unused NSUInteger idx, __unused BOOL *stop) {
                    [_placeHolder removeObject:item];
                }];
            }
        }];
    }
}

- (__autoreleasing NSString *)pathForRemoteMedia:(NSString *)remoteMedia {
    /* Condition validation */
    if (!remoteMedia || remoteMedia.length == 0) return nil;
    
    remoteMedia = [self _validateFilename:remoteMedia];
    return [_rootPath stringByAppendingPathComponent:remoteMedia];
}
- (void)updateFile:(NSString *)filename {
    /* Condition validation */
	__autoreleasing NSMutableDictionary *attributes = [[_fileManager attributesOfItemAtPath:filename error:nil] toMutableDictionary];
    if (!attributes) return;
    
    /* Condition validation: */
    NSTimeInterval seconds = -[attributes[NSFileModificationDate] timeIntervalSinceNow];
    if (seconds < (_idleTime / 2)) return;
    
    attributes[NSFileModificationDate] = [NSDate date];
    [_fileManager setAttributes:attributes ofItemAtPath:filename error:nil];
}
- (void)clearCache {
	[self _clearAllFilesAtPath:_rootPath];
}


#pragma mark - Class's private methods
- (NSString *)_validateFilename:(NSString *)filename {
    __autoreleasing NSData *data = [filename toData];
    uint8_t *chars = (void *)data.bytes;
    
    // Replace all invalid characters
    for (NSUInteger i = 0; i < data.length; i++) {
        if (chars[i] == ':' || chars[i] == '/') chars[i] = '_';
    }
    filename = [data toString];
	return filename;
}

- (void)_clearFolder {
    __autoreleasing NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:_rootPath];
    __autoreleasing NSString *filename = [enumerator nextObject];
    
    while (filename) {
        filename = [NSString stringWithFormat:@"%@%@", _rootPath, filename];
        
        // Load file's attributes
        NSDictionary *attributes = [_fileManager attributesOfItemAtPath:filename error:nil];
        NSTimeInterval seconds = -1 * [attributes fileModificationDate].timeIntervalSinceNow;
        
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
    /* Condition validation */
    if (!named || named.length == 0) return nil;
    return FwiAutoRelease([[FwiCacheFolder alloc] initWithNamed:named]);
}


#pragma mark - Class's constructors
- (instancetype)initWithNamed:(NSString *)named {
	self = [self init];
    if (self) {
        _rootPath = FwiRetain([[[NSURL cacheDirectory] path] stringByAppendingPathComponent:named]);
        
        /* Condition validation: Validate paths */
        BOOL isFolder  = NO;
        BOOL isExisted = [_fileManager fileExistsAtPath:_rootPath isDirectory:&isFolder];
        
        if (isExisted && isFolder) {
            // Do nothing
        }
        else if (isExisted && !isFolder) {
            [_fileManager removeItemAtPath:_rootPath error:nil];
            [_fileManager createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else {
            [_fileManager createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //delete any half loaded files
        [self _clearFolder];
	}
	return self;
}


@end
