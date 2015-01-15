//  Project name: FwiCore
//  File name   : FwiBase64DataTest.m
//
//  Author      : Phuc, Tran Huu
//  Created date: 1/14/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (C) 2012, 2015 Monster Group.
//  All Rights Reserved.
//  --------------------------------------------------------------

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


@interface FwiBase64DataTest : XCTestCase {
}

@end


@implementation FwiBase64DataTest


#pragma mark - Setup
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


#pragma mark - Tear Down
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - Test Cases
- (void)testIsBase64 {
    NSData *base64Data = nil;
    XCTAssertFalse([base64Data isBase64], @"Nil data should always return false.");
    
    base64Data = [@"" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    XCTAssertFalse([base64Data isBase64], @"Empty data should always return false.");

    base64Data = [@"FwiCore" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    XCTAssertFalse([base64Data isBase64], @"Invalid data length should always return false.");
    
    base64Data = [@"つながって" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    XCTAssertFalse([base64Data isBase64], @"Unicode data [つながって] should always return false.");
    
    base64Data = [@"44Gk44Gq4 4GM44Gj44Gm" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    XCTAssertFalse([base64Data isBase64], @"44Gk44Gq4 4GM44Gj44Gm is an invalid base64.");
    
    base64Data = [@"44Gk44Gq44GM44Gj44Gm" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    XCTAssertTrue([base64Data isBase64], @"44Gk44Gq44GM44Gj44Gm is a valid base64.");
}

- (void)testDecodeBase64Data {
    NSData *base64Data = nil;
    XCTAssertNil([base64Data decodeBase64Data], @"Nil data should always return nil.");
    
    base64Data = [@"44Gk44Gq44GM44Gj44Gm" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSData *data = [@"つながって" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    XCTAssertEqualObjects([base64Data decodeBase64Data], data, @"44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.");
}
- (void)testDecodeBase64String {
    NSData *base64Data = nil;
    XCTAssertNil([base64Data decodeBase64String], @"Nil data should always return nil.");
    
    base64Data = [@"44Gk44Gq44GM44Gj44Gm" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    XCTAssertEqualObjects([base64Data decodeBase64String], @"つながって", @"44Gk44Gq44GM44Gj44Gm should be return as つながって after decoded.");
}

- (void)testEncodeBase64Data {
//    var data: NSData? = nil
//    XCTAssertNil(data?.encodeBase64Data(), "Nil data should always return nil.")
//    
//    data = "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//    XCTAssertNil(data?.encodeBase64Data(), "Empty data should return nil.")
//    XCTAssertNil(data?.encodeBase64String(), "Empty data should return nil.")
//    
//    data = "つながって".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//    var base64Data = "44Gk44Gq44GM44Gj44Gm".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//    XCTAssert(data?.encodeBase64Data() == base64Data, "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")
}
- (void)testEncodeBase64String {
//    var data: NSData? = nil
//    XCTAssertNil(data?.encodeBase64String(), "Nil data should always return nil.")
//    
//    XCTAssertNil("".encodeBase64Data(), "Empty string should return nil.")
//    XCTAssertNil("".encodeBase64String(), "Empty string should return nil.")
//    
//    data = "つながって".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//    XCTAssert(data?.encodeBase64String() == "44Gk44Gq44GM44Gj44Gm", "つながって should be return as 44Gk44Gq44GM44Gj44Gm after encoded.")
}


@end
