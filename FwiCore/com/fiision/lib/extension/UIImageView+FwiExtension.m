#import "UIImageView+FwiExtension.h"


@implementation UIImageView (FwiExtension)


static FwiCacheFolder *_CacheFolder;
+ (void)initialize {
    if (!_CacheFolder) {
        _CacheFolder = FwiRetain([FwiCacheFolder cacheFolderWithNamed:@"images"]);
    }
}


#pragma mark - Class's properties
- (NSURL *)remoteURL {
    return objc_getAssociatedObject(self, @selector(remoteURL));
}
- (void)setRemoteURL:(NSURL *)remoteURL {
    objc_setAssociatedObject(self, @selector(remoteURL), remoteURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Class's public methods
- (void)downloadImageURL:(NSString *)imageURL {
    /* Condition validation */
    if (!imageURL || imageURL.length == 0) return;
    
    /* Condition validation: validate image url */
    __autoreleasing NSURL *url = [NSURL URLWithString:imageURL];
    if (!url) return;
    
    self.remoteURL = url;
    [_CacheFolder handleDelegate:self];
}


#pragma mark - FwiCacheFolderDelegate's members
- (__autoreleasing NSURL *)remoteMedia:(FwiCacheFolder *__unused)cacheFolder {
    return self.remoteURL;
}
- (void)cacheFolder:(FwiCacheFolder *__unused)cacheFolder willDownloadRemoteMedia:(NSURL *__unused)remoteURL {
    __autoreleasing UIActivityIndicatorView *indicatorView = [self viewWithTag:1000];
    if (!indicatorView) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.tag = 1000;
        indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:indicatorView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Apply constraints
        __autoreleasing NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:indicatorView
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1
                                                                               constant:0];
        __autoreleasing NSLayoutConstraint *c2 = [NSLayoutConstraint constraintWithItem:indicatorView
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1
                                                                               constant:0];
        [self addConstraints:@[c1, c2]];
    }
    
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
}
- (void)cacheFolder:(FwiCacheFolder *__unused)cacheFolder didFinishDownloadingRemoteMedia:(NSURL *)remoteURL image:(UIImage *)image {
    /* Condition validation */
    if (![remoteURL isEqual:self.remoteURL]) return;
    
    // set image
    dispatch_async(dispatch_get_main_queue(), ^{
        __autoreleasing UIActivityIndicatorView *indicatorView = [self viewWithTag:1000];
        [indicatorView stopAnimating];
        indicatorView.hidden = YES;
        self.image = image;
    });
    self.remoteURL = nil;
}


@end
