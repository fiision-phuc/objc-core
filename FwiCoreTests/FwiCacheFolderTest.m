//
//  FwiCacheFolderTest.m
//  FwiCore
//
//  Created by Phuc, Tran Huu on 4/3/16.
//  Copyright © 2016 Fiision Studio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FwiCacheFolder.h"


@interface FwiCacheFolderTest : XCTestCase <FwiCacheFolderDelegate> {
    
@private
    XCTestExpectation *_e;
    FwiCacheFolder *_cacheFolder;
}

@end


@implementation FwiCacheFolderTest


#pragma mark - Setup
- (void)setUp {
    [super setUp];
    
    XCTAssertNil([FwiCacheFolder cacheFolderWithNamed:@""], @"Expected nil when defining empty named.");
    XCTAssertNil([FwiCacheFolder cacheFolderWithNamed:nil], @"Expected nil when defining invalid named.");
    
    _cacheFolder = FwiRetain([FwiCacheFolder cacheFolderWithNamed:@"images"]);
    XCTAssertEqual(_cacheFolder.idleTime, 172800, @"Expected initial idleTime would be 2 days.");   // 2 * 24 * 60 * 60
    
    __autoreleasing NSString *rootPath = [[[NSURL cacheDirectory] path] stringByAppendingPathComponent:@"images"];
    XCTAssertEqualObjects(_cacheFolder.rootPath, rootPath, @"Expected root path will be cache path and named.");
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL isExisted = [manager fileExistsAtPath:_cacheFolder.rootPath isDirectory:&isDirectory];
    XCTAssertTrue(isDirectory, @"Expected root path is directory.");
    XCTAssertTrue(isExisted, @"Expected root path must be created.");
}


#pragma mark - Tear Down
- (void)tearDown {
    [_cacheFolder clearCache];
    FwiRelease(_cacheFolder);
    FwiRelease(_e);
    [super tearDown];
}


#pragma mark - Test Cases
- (void)testPathForFilename {
    NSString *urlString = @"https://www.planwallpaper.com/static/images/desktop-year-of-the-tiger-images-wallpaper.jpg";
    NSString *formattedUrlString = @"https___www.planwallpaper.com_static_images_desktop-year-of-the-tiger-images-wallpaper.jpg";
    
    XCTAssertNil([_cacheFolder pathForRemoteMedia:nil], @"Expected nil when defining empty named.");
    XCTAssertNil([_cacheFolder pathForRemoteMedia:nil], @"Expected nil when defining invalid named.");
    XCTAssertEqualObjects([_cacheFolder pathForRemoteMedia:urlString], [_cacheFolder.rootPath stringByAppendingPathComponent:formattedUrlString], @"Expected \"%@\" but found \"%@\".", [_cacheFolder.rootPath stringByAppendingPathComponent:formattedUrlString], [_cacheFolder pathForRemoteMedia:urlString]);
}

- (void)testHandleDelegate {
    _e = [self expectationWithDescription:@"Operation completed."];
    [_cacheFolder handleDelegate:self];
    
    [self waitForExpectationsWithTimeout:60.0f handler:^(NSError * _Nullable error) {
        if (error) {
            XCTAssertThrows(@"Operation could not finish.");
        }
    }];
}


#pragma mark - FwiCacheFolderDelegate's members
- (__autoreleasing NSURL *)remoteMedia:(FwiCacheFolder * __unused)cacheFolder {
    XCTAssertEqualObjects(_cacheFolder, _cacheFolder, @"Expected the same cache folder.");
    
    return [NSURL URLWithString:@"https://www.planwallpaper.com/static/images/desktop-year-of-the-tiger-images-wallpaper.jpg"];
}
- (void)cacheFolder:(FwiCacheFolder * __unused)cacheFolder willDownloadRemoteMedia:(NSURL * __unused)remoteURL {
    XCTAssertEqualObjects(_cacheFolder, _cacheFolder, @"Expected the same cache folder.");
    XCTAssertEqualObjects(remoteURL, [NSURL URLWithString:@"https://www.planwallpaper.com/static/images/desktop-year-of-the-tiger-images-wallpaper.jpg"], @"Expected the same remote url.");
}
- (void)cacheFolder:(FwiCacheFolder * __unused)cacheFolder didFinishDownloadingRemoteMedia:(NSURL * __unused)remoteURL image:(UIImage * __unused)image {
    XCTAssertEqualObjects(_cacheFolder, _cacheFolder, @"Expected the same cache folder.");
    XCTAssertEqualObjects(remoteURL, [NSURL URLWithString:@"https://www.planwallpaper.com/static/images/desktop-year-of-the-tiger-images-wallpaper.jpg"], @"Expected the same remote url.");
    
    XCTAssertNotNil(image, @"Expected image not nil.");
    
    NSString *path = [_cacheFolder pathForRemoteMedia:@"https://www.planwallpaper.com/static/images/desktop-year-of-the-tiger-images-wallpaper.jpg"];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path], @"Expected success downloaded image will be available.");
    
    [_e fulfill];
}


@end
