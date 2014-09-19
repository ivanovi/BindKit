//
//  BindKitUnitsTests.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/19/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BindKitTestCase.h"

@interface BindKitUnitsTests : BindKitTestCase

@end

@implementation BindKitUnitsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - CREBindingUnit

-(void)testBindingUnitComparisons{
    
    
    CREBindingUnit * testBindingUnit = [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aDictionary}];
    
    BOOL result = [testBindingUnit compareWithDict:@{aProperty:aDictionary}];
    XCTAssert(result, @"BindingUnit test comaparison failed %s", __PRETTY_FUNCTION__);
    
    result = [testBindingUnit compareWithDict:@{bProperty:bDictionary}];
    XCTAssert(!result, @"BindingUnit negative comparison failed %s", __PRETTY_FUNCTION__ );
    
}

-(void)testBindingUnitInitialization{
    
    
    CREBindingUnit *testUnit = [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aDictionary}];
    
    XCTAssert(testUnit, @"BindingUnit initializaiton failed");
    XCTAssertTrue([testUnit.boundObject isEqual: aDictionary], @"BindingUnit property setup failed at initialization for boundObject");
    XCTAssertTrue([testUnit.boundObjectProperty isEqual: aProperty], @"BindingUnit property setup failed at initialization for property");
    
}



@end
