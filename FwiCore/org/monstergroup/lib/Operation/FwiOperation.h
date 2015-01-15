//  Project name: FwiCore
//  File name   : FwiOperation.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/4/12
//  Version     : 1.20
//  --------------------------------------------------------------
//  Copyright (C) 2012, 2015 Monster Group.
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
//  testing. Monster Group  disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, FwiOPState) {
    kOPState_Initialize = 0x00,
    kOPState_Cancelled  = 0x01,
    kOPState_Error      = 0x02,
    kOPState_Executing	= 0x03,
    kOPState_Finished	= 0x04
};  // Operation stage


@protocol FwiOperationDelegate;


@interface FwiOperation : NSOperation {

@protected
    NSDictionary *_userInfo;
    FwiOPState   _state;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign, getter=isLongOperation) BOOL longOperation;


/** Provide gateway to access to internal operationQueue. */
+ (NSOperationQueue *)operationQueue;


/** Execute this operation. */
- (void)execute;
/** Implement business logic. */
- (void)executeBusiness;

@end


@interface FwiOperation (FwiOperationExtension)

/** Execute with completion block. */
- (void)executeWithCompletion:(void(^)(void))completion;

@end


@protocol FwiOperationDelegate <NSObject>

@optional
/** Notify delegate this operation will start. */
- (void)operationWillStart:(FwiOperation *)operation;
/** Notify delegate this operation was cancelled. */
- (void)operationDidCancel:(FwiOperation *)operation;
/** Notify delegate that this operation finished. */
- (void)operation:(FwiOperation *)operation didFinishWithStage:(FwiOPState)stage userInfo:(NSDictionary *)userInfo;

@end
