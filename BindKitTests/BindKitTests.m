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
#import "BindKitTestCase.h"
#import "CREBindTestHelper.h"

//TODO: Add more descriptive errors


@interface BindKitTests : BindKitTestCase

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


#pragma mark - CREBindintRelation

- (void)testBindingDefintionInit{
    
    CREBindRelation *aDefinition = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty] sourceObjects:@[aDictionary, bDictionary]];
    
    for (CREBindingUnit *aBindingUnit in aDefinition.bindingUnits)
    {
       
        XCTAssertTrue( [aTestMappingDictionary [aBindingUnit.boundObjectProperty] isEqual: aBindingUnit.boundObject],
                      @"BindingDefinition test failed");
        
    }
    
}
//TODO: add assertion
- (void)testBindingDefintionAddBindingUnit{
    
    CREBindRelation *aDefinition = [CREBindRelation new];
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
    
    CREBindRelation *aDefinition = [CREBindRelation new];
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






//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
