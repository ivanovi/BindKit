//
//  CREBindTestHelper.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/10/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


//@interface BindKitTests : XCTestCase  {
//    
//    NSDictionary * aDictionary, *bDictionary, *cDictionary;
//    NSDictionary * aTestMappingDictionary;
//    
//    NSString *aTestValue, *bTestValue, *cTestValue;
//    NSString *aProperty, *bProperty, *cProperty;;
//    
//}

@interface CREBindTestHelper : NSObject

-(instancetype)initForRemoteTests;

@property (nonatomic, strong) NSDictionary * aDictionary, *bDictionary, *cDictionary, *aTestMappingDictionary;
@property (nonatomic, strong) NSString *aTestValue, *bTestValue, *cTestValue;
@property (nonatomic, strong) NSString *aProperty, *bProperty, *cProperty;

@end
