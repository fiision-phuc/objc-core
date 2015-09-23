#import <netdb.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "FwiReachability.h"


NSString *kNotification_ReachabilityStateChanged = @"kNotification_ReachabilityStateChanged";


static void printFlags(SCNetworkReachabilityFlags flags) {
#pragma unused (flags)

    DLog(@"Reachability status: %c%c %c%c%c%c%c%c%c",
         (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',                     // Can be reached via an EDGE, GPRS, or other "cell" connection.
         (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',                     // Can be reached using the current network configuration.

         (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',                     // Can be reached via a transient connection, such as PPP.
         (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',                     // Can be reached using the current network configuration, but a connection must first be established, such as dialup.
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',                     // Can be reached using the current network configuration, but a connection must first be established. Any traffic directed to the specified name or address will initiate the connection.
         (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',                     // Can be reached using the current network configuration, but a connection must first be established. In addition, some forms will be required to establish this connection.
         (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',                     // Can be reached using the current network configuration, but a connection must first be established. The connection will be established "On Demand".
         (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',                     // The specified nodename or address is one associated with a network interface on the current system.
         (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-');                    // The specified nodename or address will be routed directly to one of the interfaces in the system.
}
static void reachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
#pragma unused (target)

    printFlags(flags);
    FwiReachability *reachability = (__bridge FwiReachability*) info;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ReachabilityStateChanged object:reachability];
}


@interface FwiReachability () {

    SCNetworkReachabilityRef _reachabilityRef;
}

@property (nonatomic, assign) BOOL returnWiFiStatus;


/** Check WiFi/Network status for flags. */
- (FwiReachabilityState)_statusWiFiWithFlags:(SCNetworkReachabilityFlags)flags;
- (FwiReachabilityState)_statusInternetWithFlags:(SCNetworkReachabilityFlags)flags;

@end


@implementation FwiReachability


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        _returnWiFiStatus = NO;
        _reachabilityRef  = NULL;
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    [self stop];
    FwiReleaseCF(_reachabilityRef);

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties
- (FwiReachabilityState)reachabilityStatus {
    /* Condition validation */
    if (!_reachabilityRef) return kReachability_None;

    SCNetworkReachabilityFlags flags = 0;
	FwiReachabilityState status = kReachability_None;

	if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
        status = (_returnWiFiStatus ? [self _statusWiFiWithFlags:flags] : [self _statusInternetWithFlags:flags]);
	}
	return status;
}
- (BOOL)isConnectionRequired {
    /* Condition validation */
    if (!_reachabilityRef) return NO;

	SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(_reachabilityRef, &flags);
    return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
}


#pragma mark - Class's public methods
- (void)start {
    /* Condition validation */
    if (!_reachabilityRef) return;

	SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

    /* Condition validation: Stop if could not register callback method */
	if (!SCNetworkReachabilitySetCallback(_reachabilityRef, reachabilityCallback, &context)) return;

    // Add to default runloop
    SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
}
- (void)stop {
    /* Condition validation */
    if (!_reachabilityRef) return;
    SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
}


#pragma mark - Class's private methods
- (FwiReachabilityState)_statusWiFiWithFlags:(SCNetworkReachabilityFlags)flags {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect));
    return (isReachable ? kReachability_WiFi : kReachability_None);
}
- (FwiReachabilityState)_statusInternetWithFlags:(SCNetworkReachabilityFlags)flags {
    /* Condition validation */
	if (!(flags & kSCNetworkReachabilityFlagsReachable)) return kReachability_None;

    FwiReachabilityState status = (!(flags & kSCNetworkReachabilityFlagsConnectionRequired) ? kReachability_WiFi : kReachability_None);
	if (flags & kSCNetworkReachabilityFlagsIsWWAN) status = kReachability_WWAN;
    
	return status;
}


@end


@implementation FwiReachability (FwiReachabilityCreation)


#pragma mark - Class's static constructors
+ (__autoreleasing FwiReachability *)reachabilityWithAddress:(const struct sockaddr_in *)address {
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);

	__autoreleasing FwiReachability *reachability = (reachabilityRef ? FwiAutoRelease([[FwiReachability alloc] initWithNetworkReachability:reachabilityRef]) : nil);
    if (!reachability) FwiReleaseCF(reachabilityRef);

	return reachability;
}
+ (__autoreleasing FwiReachability *)reachabilityWithHostname:(NSString *)hostname {
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);

    __autoreleasing FwiReachability *reachability = (reachabilityRef ? FwiAutoRelease([[FwiReachability alloc] initWithNetworkReachability:reachabilityRef]) : nil);
    if (!reachability) FwiReleaseCF(reachabilityRef);

	return reachability;
}

+ (__autoreleasing FwiReachability *)reachabilityForInternet {
	struct sockaddr_in address;
	bzero(&address, sizeof(address));

    // Initialize IP address
	address.sin_len    = sizeof(address);
	address.sin_family = AF_INET;

	return [self reachabilityWithAddress:&address];
}
+ (__autoreleasing FwiReachability *)reachabilityForWiFi {
	struct sockaddr_in address;
	bzero(&address, sizeof(address));

    // Initialize WiFi address
	address.sin_len         = sizeof(address);
	address.sin_family      = AF_INET;
	address.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);

	__autoreleasing FwiReachability *reachability = [self reachabilityWithAddress:&address];
    if (reachability) reachability.returnWiFiStatus = YES;

	return reachability;
}


#pragma mark - Class's constructors
- (id)initWithNetworkReachability:(SCNetworkReachabilityRef)reachabilityRef {
    self = [self init];
    if (self) {
        _reachabilityRef = reachabilityRef;
    }
    return self;
}


@end
