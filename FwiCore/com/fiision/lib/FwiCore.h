//  Project name: FwiCore
//  File name   : FwiCore.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/21/12
//  Version     : 1.20
//  --------------------------------------------------------------
//  Copyright (C) 2012, 2015 Fiision Studio.
//  All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

#ifndef __FWI_CORE__
#define __FWI_CORE__


// ARC & Non-ARC Compatible
#if !defined(__bridge_transfer)
    #define __bridge_transfer           /* Empty */
#endif

#if !defined(__bridge_transfer)
#define __weak                          /* Empty */
#endif

#if __has_feature(objc_arc)
    #define FwiRetain(o)                o
    #define FwiRelease(o)               if(o) { o = nil; }
    #define FwiAutoRelease(o)           o
#else
    #define _weak                       /* Empty */
    #define FwiRetain(o)                [o retain]
    #define FwiRelease(o)               if(o) { [o release]; o = nil;  }
    #define FwiAutoRelease(o)           [o autorelease]
#endif

#define FwiReleaseCF(o)                 if(o) { CFRelease(o); o = nil; }


// Logger
#ifdef DEBUG
    #define DLog(...)                   NSLog(@"\n%s %@\n\n", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
    #define DLog(...)                   do { } while (0)
#endif


// Define degree/radians value
#define kDegreeToRadian                 0.0174532925199432957
#define kRadianToDegree                 57.295779513082320876
#define kCircle                         6.28319 // (360 degree)

// Define converter macro functions
static inline double FwiConvertToDegree(double radian) {
    double degree = radian * kRadianToDegree;
    return degree;
}
static inline double FwiConvertToRadian(double degree) {
    double radian = degree * kDegreeToRadian;
    return radian;
}


// Foundation
#import "NSArray+FwiExtension.h"
#import "NSData+FwiExtension.h"
#import "NSDictionary+FwiExtension.h"
#import "NSNumber+FwiExtension.h"
#import "NSString+FwiExtension.h"
#import "NSURL+FwiExtension.h"
// Codec
#import "NSData+FwiBase64.h"
#import "NSString+FwiBase64.h"
#import "NSData+FwiHex.h"
// UIKit
#import "UIButton+FwiExtension.h"
#import "UIColor+FwiExtension.h"
#import "UIImage+FwiExtension.h"
#import "UINavigationController+FwiExtension.h"
#import "UITabBarController+FwiExtension.h"
#import "UIView+FwiExtension.h"
// Operation
#import "FwiOperation.h"
// Reachability
#import "FwiReachability.h"


#pragma mark - i18n
#import "FwiLocalization.h"
static inline void FwiLocalizedReset() {
    [[FwiLocalization sharedInstance] reset];
}
static inline NSString* FwiLocalizedLocale() {
    return [[FwiLocalization sharedInstance] locale];
}
static inline void FwiLocalizedSetLocale(NSString *locale) {
    [[FwiLocalization sharedInstance] setLocale:locale];
}
static inline NSString* FwiLocalizedString(NSString *key) {
    return [[FwiLocalization sharedInstance] localizedForString:key alternative:key];
}


#pragma mark - Network
typedef NS_ENUM(NSInteger, FwiHttpMethod) {
    kCopy    = 0x00,
    kDelete  = 0x01,
    kGet     = 0x02,
    kHead    = 0x03,
    kLink    = 0x04,
    kOptions = 0x05,
    kPatch   = 0x06,
    kPost    = 0x07,
    kPurge   = 0x08,
    kPut     = 0x09,
    kUnlink  = 0x0a
};

typedef NS_ENUM(NSInteger, FwiNetworkStatus) {
    kNone                              = -1,
    kUnknown                           = NSURLErrorUnknown,
    kCancelled                         = NSURLErrorCancelled,
    kBadURL                            = NSURLErrorBadURL,
    kTimedOut                          = NSURLErrorTimedOut,
    kUnsupportedURL                    = NSURLErrorUnsupportedURL,
    kCannotFindHost                    = NSURLErrorCannotFindHost,
    kCannotConnectToHost               = NSURLErrorCannotConnectToHost,
    kNetworkConnectionLost             = NSURLErrorNetworkConnectionLost,
    kDNSLookupFailed                   = NSURLErrorDNSLookupFailed,
    kHTTPTooManyRedirects              = NSURLErrorHTTPTooManyRedirects,
    kResourceUnavailable               = NSURLErrorResourceUnavailable,
    kNotConnectedToInternet            = NSURLErrorNotConnectedToInternet,
    kRedirectToNonExistentLocation     = NSURLErrorRedirectToNonExistentLocation,
    kBadServerResponse                 = NSURLErrorBadServerResponse,
    kUserCancelledAuthentication       = NSURLErrorUserCancelledAuthentication,
    kUserAuthenticationRequired        = NSURLErrorUserAuthenticationRequired,
    kZeroByteResource                  = NSURLErrorZeroByteResource,
    kCannotDecodeRawData               = NSURLErrorCannotDecodeRawData,
    kCannotDecodeContentData           = NSURLErrorCannotDecodeContentData,
    kCannotParseResponse               = NSURLErrorCannotParseResponse,
    kFileDoesNotExist                  = NSURLErrorFileDoesNotExist,
    kFileIsDirectory                   = NSURLErrorFileIsDirectory,
    kNoPermissionsToReadFile           = NSURLErrorNoPermissionsToReadFile,
    kDataLengthExceedsMaximum          = NSURLErrorDataLengthExceedsMaximum,
    // SSL errors
    kSecureConnectionFailed            = NSURLErrorSecureConnectionFailed,
    kServerCertificateHasBadDate       = NSURLErrorServerCertificateHasBadDate,
    kServerCertificateUntrusted        = NSURLErrorServerCertificateUntrusted,
    kServerCertificateHasUnknownRoot   = NSURLErrorServerCertificateHasUnknownRoot,
    kServerCertificateNotYetValid      = NSURLErrorServerCertificateNotYetValid,
    kClientCertificateRejected         = NSURLErrorClientCertificateRejected,
    kClientCertificateRequired         = NSURLErrorClientCertificateRequired,
    kCannotLoadFromNetwork             = NSURLErrorCannotLoadFromNetwork,
    // Download and file I/O errors
    kCannotCreateFile                  = NSURLErrorCannotCreateFile,
    kCannotOpenFile                    = NSURLErrorCannotOpenFile,
    kCannotCloseFile                   = NSURLErrorCannotCloseFile,
    kCannotWriteToFile                 = NSURLErrorCannotWriteToFile,
    kCannotRemoveFile                  = NSURLErrorCannotRemoveFile,
    kCannotMoveFile                    = NSURLErrorCannotMoveFile,
    kDownloadDecodingFailedMidStream   = NSURLErrorDownloadDecodingFailedMidStream,
    kDownloadDecodingFailedToComplete  = NSURLErrorDownloadDecodingFailedToComplete,
    
    kInternationalRoamingOff           = NSURLErrorInternationalRoamingOff,
    kCallIsActive                      = NSURLErrorCallIsActive,
    kDataNotAllowed                    = NSURLErrorDataNotAllowed,
    kRequestBodyStreamExhausted        = NSURLErrorRequestBodyStreamExhausted,
};

static inline BOOL FwiNetworkStatusIsSuccces(NSInteger statusCode) {
    return (200 <= statusCode && statusCode <= 299);
}

#import "FwiNetworkManager.h"
#import "FwiRequest.h"
#import "FwiDataParam.h"
#import "FwiFormParam.h"
#import "FwiMultipartParam.h"


#endif
