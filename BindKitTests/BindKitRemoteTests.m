//
//  BindKitRemoteTests.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/10/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRERemoteBinder.h"

@interface BindKitRemoteTests : XCTestCase{
    
    
    NSDictionary * aDictionary, *bDictionary, *cDictionary;
    NSDictionary * aTestMappingDictionary;
    
    NSString *aTestValue, *bTestValue, *cTestValue;
    NSString *aProperty, *bProperty, *cProperty;;
    
}


@end

@implementation BindKitRemoteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    aDictionary = [self baseDictionaryWithName:@"aDictionary"];
    bDictionary = [self baseDictionaryWithName:@"bDictionary"];
    cDictionary = [self baseDictionaryWithName:@"cDictionary"];
    
    [self baseTestValues];
    [self baseProperties];
    
    aTestMappingDictionary = @{aProperty:aDictionary,
                               bProperty:bDictionary};

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBaseRemoteBinding{
    // This is an example of a functional test case.
    
   XCTestExpectation *connectionExpectation = [self expectationWithDescription:@"fetchData"];
    
    
    CRERemoteBinder *newBinder =[CRERemoteBinder binderWithProperties:@[aProperty, bProperty] sourceObjects:@[aDictionary, bDictionary] ];
    
    
    
    [(CRERemoteBindingTransaction*)newBinder.transactions.lastObject setCallBack:^(id newValue, CREBindingUnit *unit, NSError *error){
        
        
        [connectionExpectation fulfill];
        
    }];
    

    [newBinder bind];
    
    [aDictionary setValue:aTestValue forKey:aProperty];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        
        NSLog(@"waiting finished");
        
    }];
    
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


-(NSDictionary*)baseDictionaryWithName:(NSString*)name{
    
    return [NSMutableDictionary dictionaryWithObject:name
                                              forKey:@"name"];
}

-(void)baseTestValues{
    
    aTestValue = @"http://jsonplaceholder.typicode.com/posts";
    bTestValue = @"bTest";
    cTestValue = @"cTest";
    
}

-(void)baseProperties{
    
    aProperty = @"propertyA";
    bProperty = @"propertyB";
    cProperty = @"propertyC";
    
}

-(void)assertBindingUnit:(CREBindingUnit*)oneUnit withBindingUnit:(CREBindingUnit*)secondUnit{
    
    XCTAssertTrue( [oneUnit.boundObject isEqual:secondUnit.boundObject], @"Failed addinig bindingUnit" );
    XCTAssertTrue( [oneUnit.boundObjectProperty isEqual:secondUnit.boundObjectProperty], @"Failed addinig bindingUnit" );
    
}
@end
