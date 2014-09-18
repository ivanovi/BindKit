//
//  BindKitTestCase.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/18/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "BindKitTestCase.h"
#import "CREBindTestHelper.h"

@implementation BindKitTestCase



- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    helper = [CREBindTestHelper new];
    
    aDictionary = helper.aDictionary;
    bDictionary = helper.bDictionary;
    cDictionary = helper.cDictionary;
    
    [self baseTestValues];
    [self baseProperties];
    
    aTestMappingDictionary = helper.aTestMappingDictionary;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(void)baseTestValues{
    
    aTestValue = helper.aTestValue;
    bTestValue = helper.bTestValue;
    cTestValue = helper.cTestValue;
    
}

-(void)baseProperties{
    
    aProperty = helper.aProperty;
    bProperty = helper.bProperty;
    cProperty = helper.cProperty;
    
}


-(void)assertBindingUnit:(CREBindingUnit*)oneUnit withBindingUnit:(CREBindingUnit*)secondUnit{
    
    XCTAssertTrue( [oneUnit.boundObject isEqual:secondUnit.boundObject], @"Failed addinig bindingUnit" );
    XCTAssertTrue( [oneUnit.boundObjectProperty isEqual:secondUnit.boundObjectProperty], @"Failed addinig bindingUnit" );
    
}


@end
