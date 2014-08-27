//
//  BindKitTests.m
//  BindKitTests
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BindKit.h"

@interface BindKitTests : XCTestCase

@end

@implementation BindKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testBaseBinding{

    NSMutableDictionary *aDictionary = [NSMutableDictionary new];
    NSMutableDictionary *bDictionary = [NSMutableDictionary new];
    
    CREBinder *newBinder = [CREBinder binderWithMapping:@{@"propertyA":aDictionary,
                                                          @"propertyB":bDictionary}];
    [newBinder bind];
    
    [aDictionary setValue:@"testA" forKey:@"propertyA"];
    
    XCTAssertEqualObjects(aDictionary [@"propertyA"], bDictionary [@"propertyB"], @"Failed test");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
