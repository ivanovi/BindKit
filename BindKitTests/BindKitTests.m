//
//  BindKitTests.m
//  BindKitTests
//
//  Created by Ivan Ivanov on 8/27/14.
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
#import "BindKit.h"
#import "CREBindingUnit.h"
#import "CREBindTestHelper.h"

//TODO: Add more descriptive errors


@interface BindKitTests : XCTestCase  {
 
    NSDictionary * aDictionary, *bDictionary, *cDictionary;
    NSDictionary * aTestMappingDictionary;
    
    NSString *aTestValue, *bTestValue, *cTestValue;
    NSString *aProperty, *bProperty, *cProperty;;
    
    CREBindTestHelper *helper;
    
}

@end

@implementation BindKitTests

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

-(void)testBaseBinderTransactionCreation{
    
    CREBinder *newBinder = [CREBinder new];
    
    CREBindingTransaction *aTransaction = [[CREBindingTransaction alloc] initWithProperties:@[aProperty, bProperty]
                                                                              sourceObjects:@[aDictionary, bDictionary]];
    [newBinder addTransaction:aTransaction];
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

#pragma mark - Transaction composition

-(void)testBaseBinderTransactionCompositionAdd{
    
    CREBinder *newBinder = [CREBinder new];
    
    XCTAssertNil(newBinder.transactions, @"Failed base test %s", __PRETTY_FUNCTION__);
    
    CREBindingTransaction *aTransaction = [[CREBindingTransaction alloc] initWithProperties:@[aProperty, bProperty]
                                                                              sourceObjects:@[aDictionary, bDictionary]];
    //add positive
    [newBinder addTransaction:aTransaction];
    
    XCTAssertTrue(newBinder.transactions.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([newBinder.transactions containsObject:aTransaction], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    //remove positive
    [newBinder removeTransaction:aTransaction];
    XCTAssertTrue(newBinder.transactions.count == 0 , @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(![newBinder.transactions containsObject:aTransaction], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    
    CREBindingTransaction *bTransaction = [[CREBindingTransaction alloc] initWithProperties:@[aProperty, bProperty]
                                                                              sourceObjects:@[aDictionary, bDictionary]];
    //add negative
    [newBinder addTransaction:bTransaction];
    XCTAssertTrue(newBinder.transactions.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(![newBinder.transactions containsObject:aTransaction], @"Failed base test %s", __PRETTY_FUNCTION__);
    
    //remove negative
    [newBinder removeTransaction:aTransaction];
    XCTAssertTrue(newBinder.transactions.count == 1, @"Failed base test %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([newBinder.transactions containsObject:bTransaction], @"Failed base test %s", __PRETTY_FUNCTION__);
    
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

#pragma mark - CREBindingUnit

-(void)testBindingUnitComparisons{
    
    
    CREBindingUnit * testBindingUnit = [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aDictionary}];
    
    BOOL result = [testBindingUnit compareWithDict:@{aProperty:aDictionary}];
    XCTAssert(result, @"BindingUnit test comaparison failed %s", __PRETTY_FUNCTION__);
      
    result = [testBindingUnit compareWithDict:@{bProperty:bDictionary}];
    XCTAssert(!result, @"BindingUnit negative comparison failed %s", __PRETTY_FUNCTION__ );
              
}
              
-(void)testBindingUnitInitialization{
    
    UILabel *aLabel = [UILabel new];
    
    CREBindingUnit *testUnit = [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aDictionary}];
    
    XCTAssert(testUnit, @"BindingUnit initializaiton failed");
    XCTAssertTrue([testUnit.boundObject isEqual: aDictionary], @"BindingUnit property setup failed at initialization for boundObject");
    XCTAssertTrue([testUnit.boundObjectProperty isEqual: aProperty], @"BindingUnit property setup failed at initialization for property");

}

//-(void)testBindingUnitInitializationNegative{
//    
//    UILabel *aLabel = [UILabel new];
//    XCTAssertThrows( [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aLabel}], @"BindingUnit initializaiton negative test failed");
//    
//}


#pragma mark - CREBindintTransaction

- (void)testBindingDefintionInit{
    
    CREBindingTransaction *aDefinition = [[CREBindingTransaction alloc] initWithProperties:@[aProperty, bProperty] sourceObjects:@[aDictionary, bDictionary]];
    
    for (CREBindingUnit *aBindingUnit in aDefinition.bindingUnits)
    {
       
        XCTAssertTrue( [aTestMappingDictionary [aBindingUnit.boundObjectProperty] isEqual: aBindingUnit.boundObject],
                      @"BindingDefinition test failed");
        
    }
    
}
//TODO: add assertion
- (void)testBindingDefintionAddBindingUnit{
    
    CREBindingTransaction *aDefinition = [CREBindingTransaction new];
    CREBindingUnit *bindingUnit = [[CREBindingUnit alloc] initWithDictionary:@{cProperty: cDictionary}];
    
    [aDefinition addBindingUnit:bindingUnit];

    for (CREBindingUnit *aBindingUnit in aDefinition.bindingUnits)
    {
        
        [self assertBindingUnit:aBindingUnit withBindingUnit:bindingUnit];
        
    }
    
    CREBindingUnit *secondUnit = [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aDictionary}];
    
    [aDefinition addBindingUnit:secondUnit];
    
    NSSet *helpSet = [NSSet setWithObjects:secondUnit,bindingUnit, nil];
    
    
    for ( CREBindingUnit *aBindingUnit in helpSet)
    {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"boundObjectProperty == %@", aBindingUnit.boundObjectProperty];
        NSArray *resultArray = [aDefinition.bindingUnits filteredArrayUsingPredicate:predicate];
        
        CREBindingUnit *fetchedUnit = resultArray.lastObject;
        
        [self assertBindingUnit:fetchedUnit withBindingUnit:aBindingUnit];
    }
    
     
}

-(void)testBindingDefinitionAddBindingUnitWithDictionary{
    
    CREBindingTransaction *aDefinition = [CREBindingTransaction new];
    NSDictionary *baseDictionary = @{cProperty: cDictionary};
    
    [aDefinition addBindingUnitWithDictionary: baseDictionary];
    
    for (CREBindingUnit *aBindingUnit in aDefinition.bindingUnits)
    {
        
        XCTAssertTrue( [baseDictionary.allKeys.lastObject isEqual:aBindingUnit.boundObjectProperty], @"Failed addinig bindingUnit with dict" );
        XCTAssertTrue( [baseDictionary.allValues.lastObject isEqual:aBindingUnit.boundObject], @"Failed addinig bindingUnit with dict" );
        
    }
    
   
    NSDictionary *secondDict = @{aProperty: aDictionary};
    
    [aDefinition addBindingUnitWithDictionary:secondDict];
    
    NSSet *helpSet = [NSSet setWithObjects:baseDictionary,secondDict, nil];
    
    
    for ( NSDictionary *aDict in helpSet)
    {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"boundObjectProperty == %@", aDict.allKeys.lastObject];
        NSArray *resultArray = [aDefinition.bindingUnits filteredArrayUsingPredicate:predicate];
        
        CREBindingUnit *fetchedUnit = resultArray.lastObject;
        
        XCTAssertTrue( [aDict.allKeys.lastObject isEqual:fetchedUnit.boundObjectProperty], @"Failed addinig bindingUnit with dict second time" );
        XCTAssertTrue( [aDict.allValues.lastObject isEqual:fetchedUnit.boundObject], @"Failed addinig bindingUnit with dict second time" );
        
    }

    
}

#pragma mark - Support


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




//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
