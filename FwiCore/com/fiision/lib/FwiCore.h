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

#if __has_feature(objc_arc)
    #define _weak                       __weak
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
#import "UIImage+FwiExtension.h"
#import "UIView+FwiExtension.h"
// i18n
#import "FwiLocalization.h"
// Operation
#import "FwiOperation.h"
// Reachability
#import "FwiReachability.h"


// i18n
#define FwiLocalizedReset()             [[FwiLocalization sharedInstance] reset]
#define FwiLocalizedLocale()            [[FwiLocalization sharedInstance] locale]
#define FwiLocalizedSetLocale(locale)   [[FwiLocalization sharedInstance] setLocale:locale]
#define FwiLocalizedString(key)         [[FwiLocalization sharedInstance] localizedForString:key alternative:key]


// Color Converter
#define FwiColorWithRGB(rgb)            [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0f green:((float)((rgb & 0xFF00) >> 8))/255.0f blue:((float)(rgb & 0xFF))/255.0f alpha:1.0f]
#define FwiColorWithRGBA(rgba)          [UIColor colorWithRed:((float)((rgba & 0xFF000000) >> 24))/255.0f green:((float)((rgba & 0x00FF0000) >> 16))/255.0f blue:((float)((rgba & 0x0000FF00) >> 8))/255.0f alpha:((float)(rgba & 0x000000FF))/255.0f]


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


#endif
