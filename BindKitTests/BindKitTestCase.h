//
//  BindKitTestCase.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/18/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CREBinder.h"


@class CREBindTestHelper;

@interface BindKitTestCase : XCTestCase{
    
    NSDictionary * aDictionary, *bDictionary, *cDictionary;
    NSDictionary * aTestMappingDictionary;
    
    NSString *aTestValue, *bTestValue, *cTestValue;
    NSString *aProperty, *bProperty, *cProperty;;
    
    CREBindTestHelper *helper;
    
}

-(void)assertBindingUnit:(CREBindingUnit*)oneUnit withBindingUnit:(CREBindingUnit*)secondUnit;
-(void)baseTestValues;
-(void)baseProperties;

@end
