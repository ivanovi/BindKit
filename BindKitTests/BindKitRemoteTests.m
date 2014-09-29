//
//  BindKitRemoteTests.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/10/14.
//  Copyright (c) 2014 Ivan Ivanov, Creatub Ltd.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <BindKit/BindKit.h>
#import "CREBindTestHelper.h"

@interface BindKitRemoteTests : XCTestCase{
    
    
    NSDictionary * aDictionary, *bDictionary, *cDictionary;
    NSDictionary * aTestMappingDictionary;
    
    NSString *aTestValue, *bTestValue, *cTestValue;
    NSString *aProperty, *bProperty, *cProperty;;
    
    CREBindTestHelper *helper;
    
    
}


@end

@implementation BindKitRemoteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    helper = [[CREBindTestHelper alloc] initForRemoteTests];
    
    aDictionary = helper.aDictionary;
    bDictionary = helper.bDictionary;
    cDictionary = helper.cDictionary;
    
    aTestValue = helper.aTestValue;
    bTestValue = helper.bTestValue;
    cTestValue = helper.cTestValue;
    
    aProperty = helper.aProperty;
    bProperty = helper.bProperty;
    cProperty = helper.cProperty;
    
    aTestMappingDictionary = helper.aTestMappingDictionary;

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBaseRemoteBinding{
    // This is an example of a functional test case.
    
    XCTestExpectation *connectionExpectation = [self expectationWithDescription:@"fetchData"];
    
    CREBinder *newBinder = [CREBinder new];
    CREBindRelation * remoteRelation = [newBinder createRelationWithProperties:@[aProperty, bProperty]
                                                                 sourceObjects:@[aDictionary, bDictionary]
                                                                 relationClass:@"CRERemoteBindingRelation"];
    
    [newBinder addRelation:remoteRelation];
    void (^callBack)(id newValue, CREBindingUnit *unit, NSError *error) = ^(id newValue, CREBindingUnit *unit, NSError *error)
    {
        
        NSString *remoteKey = [helper remoteKeyForLocalKey:unit.boundObjectProperty inLocalClass:nil];
        
        XCTAssertEqualObjects(helper.remoteTestDictionary [remoteKey],
                              bDictionary [bProperty], @"RemoteBindRelation failed comprehensive test. Check the passed by the placeholder API values." );
        
        [connectionExpectation fulfill];
        
    };
    
    //setting the callBack is needed for the assertion operation
    [(CRERemoteBindingRelation*)remoteRelation setCallBack:callBack];
    
    //remoteKeyMapper
    [(CRERemoteBindingRelation*)remoteRelation setRemoteKeyMapper:helper];
    
    //Setting the url in the source unit => the first pair in the initialization
    [aDictionary setValue:aTestValue forKey:aProperty];

    //calling bind after the remote test value has been fetched independently from the bindRelation
    [helper fetchRemoteTestData:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
       
        [newBinder bind];
        
    }];
    
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError *error)
    {
        NSLog(@"waiting finished");
    }];

    
    
}




-(void)assertBindingUnit:(CREBindingUnit*)oneUnit withBindingUnit:(CREBindingUnit*)secondUnit{
    
    XCTAssertTrue( [oneUnit.boundObject isEqual:secondUnit.boundObject], @"Failed addinig bindingUnit" );
    XCTAssertTrue( [oneUnit.boundObjectProperty isEqual:secondUnit.boundObjectProperty], @"Failed addinig bindingUnit" );
    
}
@end
