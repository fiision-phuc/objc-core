//
//  FwiCoreTests.m
//  FwiCoreTests
//
//  Created by Phuc, Tran Huu on 1/13/15.
//  Copyright (c) 2015 Monster Group. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FwiCoreTests : XCTestCase

@end

@implementation FwiCoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    CGFloat a = FwiConvertToDegree(100);
    XCTAssertTrue(a == 1, @"");
}

@end
