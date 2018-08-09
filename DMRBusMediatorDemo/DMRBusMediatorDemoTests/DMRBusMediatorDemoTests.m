//
//  DMRBusMediatorDemoTests.m
//  DMRBusMediatorDemoTests
//
//  Created by Mac on 2018/8/9.
//  Copyright © 2018年 Riven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMRBusMediator.h"
#import "DMRBusMediatorProtocol.h"
#import "DMRModuleAConnector.h"

@interface DMRBusMediatorDemoTests : XCTestCase

@end

@implementation DMRBusMediatorDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testBusMediator {
    NSUInteger count = [DMRBusMediator connectorCount];
    XCTAssert(count != 0, @"DMRBusMediator error");
}

- (void)testBusMediatorCanRouteURL {
    BOOL result = [DMRBusMediator canRouteURL:[NSURL URLWithString:@"https:www.baidu.com"]];
    XCTAssert(result == NO, @"canRouteURL error");
}

@end
