#import <sys/utsname.h>
#import "FwiOperation.h"
#import "FwiCore.h"


@interface FwiOperation () {

    BOOL _isFinished;
    BOOL _isCancelled;
    BOOL _isExecuting;
}

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;


/** Clean up. */
- (void)_operationCompleted;

@end


@implementation FwiOperation


static BOOL _IsMultitaskingSupported;
static NSOperationQueue *_OperationQueue;


+ (void)initialize {
    @synchronized (self) {
        // Validate multitask
        _IsMultitaskingSupported = NO;
        if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
            _IsMultitaskingSupported = [[UIDevice currentDevice] isMultitaskingSupported];
        }
        
        // Create operation queue
        if (!_OperationQueue) {
            _OperationQueue = [[NSOperationQueue alloc] init];
            struct utsname systemInfo;
            uname(&systemInfo);
            
            __autoreleasing NSString *text = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
            if ([text hasPrefix:@"iPod"]) {
                text = [text substringFromIndex:4];
                CGFloat modelVersion = [text floatValue];
                [_OperationQueue setMaxConcurrentOperationCount:(modelVersion < 5 ? 3 : 5)];
            }
            if ([text hasPrefix:@"iPhone"]) {
                text = [text substringFromIndex:6];
                CGFloat modelVersion = [text floatValue];
                [_OperationQueue setMaxConcurrentOperationCount:(modelVersion < 4 ? 3 : 5)];
            }
            else {
                [_OperationQueue setMaxConcurrentOperationCount:5];
            }
        }
    }
}


#pragma mark - Class's static methods
+ (NSOperationQueue *)operationQueue {
    return _OperationQueue;
}


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        _isCancelled = NO;
        _isExecuting = NO;
        _isFinished  = NO;
        _userInfo    = nil;
        _state       = kOPState_Initialize;
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    _delegate = nil;
    FwiRelease(_userInfo);
    FwiRelease(_identifier);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's public methods
- (void)execute {
    // Always check for cancellation before launching the task.
    if ([self isCancelled]) {
        [self _operationCompleted];
    }
    else {
        // Register bgTask
        if (_IsMultitaskingSupported) {
            _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                /* Condition validatioN: Is long operation */
                if (self.isLongOperation) return;

                // Cancel this operation
                [self cancel];

                // Terminate background task
                if (self.bgTask != UIBackgroundTaskInvalid) {
                    [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
                    self.bgTask = UIBackgroundTaskInvalid;
                }
            }];
        }

        // Add to operation queue
        [_OperationQueue addOperation:self];
    }
}
- (void)businessLogic {
    // Dummy method.
}


#pragma mark - Class's private methods
- (void)_operationCompleted {
    // Check operation stage
    if (_state == kOPState_Executing) _state = kOPState_Finished;
    
    // Notify delegate
    if (_delegate && [_delegate respondsToSelector:@selector(operation:didFinishWithStage:userInfo:)]) {
        [_delegate operation:self didFinishWithStage:_state userInfo:_userInfo];
    }
    
    // Terminate operation
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _isExecuting = NO;
    _isFinished  = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];

    // Terminate background task
    if (_bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
    }
}


#pragma mark - NSOperation's members
- (BOOL)isAsynchronous {    // Supported from iOS 7+
    return YES;
}
- (BOOL)isExecuting {
    return _isExecuting;
}
- (BOOL)isFinished {
    return _isFinished;
}
- (BOOL)isReady {
    return YES;
}

- (void)cancel {
    _isCancelled = YES;
    _state = kOPState_Cancelled;
    
    if (_delegate && [_delegate respondsToSelector:@selector(operationDidCancel:)]) {
        [_delegate operationDidCancel:self];
    }
    [super cancel];
}

- (void)start {
    @autoreleasepool {
        // Always check for cancellation before launching the task.
        if ([self isCancelled]) {
            [self _operationCompleted];
        }
        else {
            if (_delegate && [_delegate respondsToSelector:@selector(operationWillStart:)]) {
                [_delegate operationWillStart:self];
            }
            _state = kOPState_Executing;
            
            // If the operation is not canceled, begin executing the task.
            [self willChangeValueForKey:@"isExecuting"];
            _isExecuting = YES;
            [self didChangeValueForKey:@"isExecuting"];
            
            // Process business
            [self businessLogic];
            
            // Terminate background task
            [self _operationCompleted];
        }
    }
}


@end


@implementation FwiOperation (FwiOperationExtension)


- (void)executeWithCompletion:(void(^)(void))completion {
    self.completionBlock = completion;
    [self execute];
}


@end
