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
#import "CREBindingUnit.h"

//TODO: Add more descriptive errors

@interface BindKitTests : XCTestCase  {
 
    NSDictionary * aDictionary, *bDictionary, *cDictionary;
    NSDictionary * aTestMappingDictionary;
    
    NSString *aTestValue, *bTestValue, *cTestValue;
    NSString *aProperty, *bProperty, *cProperty;;
    
}

@end

@implementation BindKitTests

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

-(void)testBindingUnitInitializationNegative{
    
    UILabel *aLabel = [UILabel new];
    XCTAssertThrows( [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aLabel}], @"BindingUnit initializaiton negative test failed");
    
}


#pragma mark - CREBindintTransaction

- (void)testBindingDefintionInit{
    
    CREBindingTransaction *aDefinition = [[CREBindingTransaction alloc] initWithProperties:@[aProperty, bProperty] sourceObjects:@[aDictionary, bDictionary]];
    
    for (CREBindingUnit *aBindingUnit in aDefinition.bindingUnits)
    {
       
        XCTAssertTrue( [aTestMappingDictionary [aBindingUnit.boundObjectProperty] isEqual: aBindingUnit.boundObject],
                      @"BindingDefinition test failed");
        
    }
    
}

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

-(NSDictionary*)baseDictionaryWithName:(NSString*)name{
    
    return [NSMutableDictionary dictionaryWithObject:name
                                       forKey:@"name"];
}

-(void)baseTestValues{

    aTestValue = @"aTest";
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



//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
