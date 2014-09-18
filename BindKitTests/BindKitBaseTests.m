//
//  BindKitBaseTests.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
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
#import "BindKitTestCase.h"

@interface BindKitBaseTests : BindKitTestCase

@end

@implementation BindKitBaseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - CREBinder: Base binding

-(void)testBaseBinding{
    
    
    CREBinder *newBinder = [CREBinder binderWithProperties:@[aProperty, bProperty] sourceObjects:@[aDictionary, bDictionary]];
    [newBinder bind];
    
    [aDictionary setValue:aTestValue forKey:aProperty];
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aDictionary setValue:bTestValue forKey:aProperty];
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [bDictionary setValue:cTestValue forKey:bProperty];
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    NSLog(@"dictionary A %@ dictionary B %@", aDictionary, bDictionary);
    
}

-(void)testBaseBindingNegative{
    
    CREBinder *newBinder = [CREBinder binderWithProperties:@[aProperty, bProperty] sourceObjects:@[aDictionary, bDictionary]];
    [newBinder bind];
    
    [aDictionary setValue:aTestValue forKey:aProperty];
    
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);
    
    [aDictionary setValue:bTestValue forKey:aProperty];
    
    XCTAssertNotEqualObjects(aTestValue , bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);
    
    [aDictionary setValue:cTestValue forKey:aProperty];
    
    XCTAssertNotEqualObjects(bTestValue , bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);
    XCTAssertNotEqualObjects(aTestValue , bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);
    
    
}

-(void)testBaseBinderRelationCreation{
    
    CREBinder *newBinder = [CREBinder new];
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    [newBinder addRelation:aRelation];
    [newBinder bind];
    
    
    //positive
    [aDictionary setValue:aTestValue forKey:aProperty];
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aDictionary setValue:bTestValue forKey:aProperty];
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [bDictionary setValue:cTestValue forKey:bProperty];
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    
    //negative
    [aDictionary setValue:aTestValue forKey:aProperty];
    XCTAssertNotEqualObjects(aDictionary [aProperty], cTestValue, @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aDictionary setValue:bTestValue forKey:aProperty];
    XCTAssertNotEqualObjects(aDictionary [aProperty], aTestValue, @"Failed base test %s", __PRETTY_FUNCTION__);
    
}

#pragma mark - Relation composition

-(void)testBaseBinderRelationCompositionAdd{
    
    CREBinder *newBinder = [CREBinder new];
    
    XCTAssertNil(newBinder.relations, @"Failed base test %s", __PRETTY_FUNCTION__);
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    //add positive
    [newBinder addRelation:aRelation];
    
    XCTAssertTrue(newBinder.relations.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([newBinder.relations containsObject:aRelation], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    //remove positive
    [newBinder removeRelation:aRelation];
    XCTAssertTrue(newBinder.relations.count == 0 , @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(![newBinder.relations containsObject:aRelation], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    
    CREBindRelation *bRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    //add negative
    [newBinder addRelation:bRelation];
    XCTAssertTrue(newBinder.relations.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(![newBinder.relations containsObject:aRelation], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    //remove negative
    [newBinder removeRelation:aRelation];
    XCTAssertTrue(newBinder.relations.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([newBinder.relations containsObject:bRelation], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    XCTAssertNoThrow([newBinder bind], @"Failed base test %s", __PRETTY_FUNCTION__);
}

#pragma mark - Binder composition

-(void)testBaseBinderComposition{
    
    CREBinder *aBinder = [[CREBinder alloc]  initWithProperties:@[aProperty, bProperty]
                                                  sourceObjects:@[aDictionary, bDictionary]];
    
    
    XCTAssertNil(aBinder.childBinders, @"Failed base test %s", __PRETTY_FUNCTION__);
    
    CREBinder *bBinder = [[CREBinder alloc]  initWithProperties:@[cProperty, bProperty]
                                                  sourceObjects:@[cDictionary, bDictionary]];
    
    CREBinder *cBinder = [[CREBinder alloc] initWithProperties:@[cProperty, aProperty]
                                                 sourceObjects:@[cDictionary, aDictionary]];
    
    [aBinder addBinder:bBinder];
    
    XCTAssert(aBinder.childBinders, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(aBinder.childBinders.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([aBinder.childBinders containsObject:bBinder], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aBinder addBinder:cBinder];
    XCTAssert(aBinder.childBinders, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(aBinder.childBinders.count == 2, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([aBinder.childBinders containsObject:cBinder], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aBinder removeBinder:bBinder];
    XCTAssert(aBinder.childBinders, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(aBinder.childBinders.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(![aBinder.childBinders containsObject:bBinder], @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([aBinder.childBinders containsObject:cBinder], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aBinder addBinder:bBinder];
    
    XCTAssert(aBinder.childBinders, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(aBinder.childBinders.count == 2, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([aBinder.childBinders containsObject:bBinder], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aBinder removeBinder:bBinder];
    [aBinder removeBinder:cBinder];
    
    XCTAssert(aBinder.childBinders.count == 0, @"Failed base test %s", __PRETTY_FUNCTION__);
    
    [aBinder addBinder:cBinder];
    [cBinder addBinder:bBinder];
    
    XCTAssertTrue([aBinder.childBinders containsObject:cBinder], @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([cBinder.childBinders containsObject:bBinder], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    XCTAssertNoThrow([aBinder bind],@"Failed base test %s", __PRETTY_FUNCTION__);
}



@end
