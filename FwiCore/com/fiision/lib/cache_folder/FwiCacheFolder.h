//  Project name: FwiCore
//  File name   : FwiCacheFolder.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/30/13
//  Version     : 1.20
//  --------------------------------------------------------------
//  Copyright © 2012, 2016 Fiision Studio.
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

#import <Foundation/Foundation.h>


@protocol FwiCacheFolderDelegate;


@interface FwiCacheFolder : NSObject {
}

@property (nonatomic, strong, readonly) NSString *rootPath;
@property (nonatomic, assign) NSTimeInterval idleTime;


/** Handle delegate object. */
- (void)handleDelegate:(id<FwiCacheFolderDelegate>)delegate;

/** Get path to downloaded file. */
- (__autoreleasing NSString *)pathForRemoteMedia:(NSString *)remoteMedia;
/** Update modification files. */
- (void)updateFile:(NSString *)filename;
/** Delete all files. */ 
- (void)clearCache;

@end


@interface FwiCacheFolder (FwiCacheCreation)

// Class's static constructors
+ (__autoreleasing FwiCacheFolder *)cacheFolderWithNamed:(NSString *)named;

@end


@protocol FwiCacheFolderDelegate <NSObject>

@required
/** Provide remote media's url. */
- (__autoreleasing NSURL *)remoteMedia:(FwiCacheFolder *)cacheFolder;

@optional
/** Notify delegate that cache folder will begin downloading remote media. */
- (void)cacheFolder:(FwiCacheFolder *)cacheFolder willDownloadRemoteMedia:(NSURL *)remoteURL;

/** Notify delegate that cache folder did finish download remote media. */
- (void)cacheFolder:(FwiCacheFolder *)cacheFolder didFinishDownloadingRemoteMedia:(NSURL *)remoteURL image:(UIImage *)image;

@end
