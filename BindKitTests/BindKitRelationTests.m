//
//  BindKitRelationTests.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/19/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BindKitTestCase.h"

@interface BindKitRelationTests : BindKitTestCase

@end

@implementation BindKitRelationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - CREBindintRelation

- (void)testBindRelationInit{
    
    NSArray *propertiesArray = @[aProperty, bProperty];
    NSArray *sourcesArray = @[aDictionary, bDictionary];
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:propertiesArray sourceObjects:sourcesArray];
    
    for (int i = 0; i < aRelation.bindingUnits.count ; i++)
    {
        CREBindingUnit * aBindingUnit = aRelation.bindingUnits [i];
        
        NSString *property = propertiesArray [i];
        id object = sourcesArray [i];
        
        XCTAssertEqualObjects(object, aBindingUnit.boundObject,  @"BindingUnit initializiation test failed in adding a boundObject.");
        XCTAssertTrue([property isEqualToString:aBindingUnit.boundObjectProperty],@"BindingUnit initializiation test failed in adding a boundObjectProperty.");
        
    }
    
}


- (void)testBindingDefintionAddBindingUnit{
    
    CREBindRelation *aRelation = [CREBindRelation new];
    CREBindingUnit *bindingUnit = [[CREBindingUnit alloc] initWithDictionary:@{cProperty: cDictionary}];
    [aRelation addBindingUnit:bindingUnit];
    
    for (CREBindingUnit *aBindingUnit in aRelation.bindingUnits)
    {
        
        [self assertBindingUnit:aBindingUnit withBindingUnit:bindingUnit];
        
    }
    
    CREBindingUnit *secondUnit = [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aDictionary}];
    [aRelation addBindingUnit:secondUnit];
    
    NSSet *helpSet = [NSSet setWithObjects:secondUnit,bindingUnit, nil];
    
    for ( CREBindingUnit *aBindingUnit in helpSet)
    {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"boundObjectProperty == %@", aBindingUnit.boundObjectProperty];
        NSArray *resultArray = [aRelation.bindingUnits filteredArrayUsingPredicate:predicate];
        
        CREBindingUnit *fetchedUnit = resultArray.lastObject;
        
        [self assertBindingUnit:fetchedUnit withBindingUnit:aBindingUnit];
    }
    
    
}

-(void)testBindingDefinitionAddBindingUnitWithDictionary{
    
    CREBindRelation *aRelation = [CREBindRelation new];
    NSDictionary *baseDictionary = @{cProperty: cDictionary};
    
    [aRelation addBindingUnitWithDictionary: baseDictionary];
    
    for (CREBindingUnit *aBindingUnit in aRelation.bindingUnits)
    {
        
        XCTAssertTrue( [baseDictionary.allKeys.lastObject isEqual:aBindingUnit.boundObjectProperty], @"Failed addinig bindingUnit with dict" );
        XCTAssertTrue( [baseDictionary.allValues.lastObject isEqual:aBindingUnit.boundObject], @"Failed addinig bindingUnit with dict" );
        
    }
    
    
    NSDictionary *secondDict = @{aProperty: aDictionary};
    
    [aRelation addBindingUnitWithDictionary:secondDict];
    
    NSSet *helpSet = [NSSet setWithObjects:baseDictionary,secondDict, nil];
    
    
    for ( NSDictionary *aDict in helpSet)
    {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"boundObjectProperty == %@", aDict.allKeys.lastObject];
        NSArray *resultArray = [aRelation.bindingUnits filteredArrayUsingPredicate:predicate];
        
        CREBindingUnit *fetchedUnit = resultArray.lastObject;
        
        XCTAssertTrue( [aDict.allKeys.lastObject isEqual:fetchedUnit.boundObjectProperty], @"Failed addinig bindingUnit with dict second time" );
        XCTAssertTrue( [aDict.allValues.lastObject isEqual:fetchedUnit.boundObject], @"Failed addinig bindingUnit with dict second time" );
        
    }
    
    
}

#pragma mark - Source unit and oneWay binding

/**
 Check BindRelation is initialized with twoWay binding and nil sourceUnit.
 */

-(void)testSourceUnitInitialState{
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    
    XCTAssertNil(aRelation.sourceUnit, @"Bind relation created source unit at initialization.");
    XCTAssertTrue(aRelation.directionType == CREBindingRelationDirectionBothWays, @"Bind relation initialized with incorrect binding direction type.");
    
    CREBindRelation *bRelation = [CREBindRelation new];
    
    XCTAssertNil(bRelation.sourceUnit, @"Bind relation created source unit at initialization.");
    XCTAssertTrue(bRelation.directionType == CREBindingRelationDirectionBothWays, @"Bind relation initialized with incorrect binding direction type.");
    
    
}

-(void)testSetSourceUnit{
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    
    CREBindingUnit *sourceUnit = aRelation.bindingUnits [0];
    CREBindingUnit *bSourceUnit = aRelation.bindingUnits [1];
    
    [aRelation setSourceBindingUnit:sourceUnit];
    
    XCTAssertTrue(aRelation.directionType == CREBindingRelationDirectionOneWay, @"Bind relation set incorrect binding direction type.");
    XCTAssertEqualObjects(aRelation.sourceUnit, sourceUnit, @"Bind relation set incorrect binding direction type.");
    
    
    [aRelation setSourceBindingUnit:bSourceUnit];
    //negative
    XCTAssertTrue(aRelation.directionType == CREBindingRelationDirectionOneWay, @"Bind relation set incorrect binding direction type.");
    XCTAssertNotEqualObjects(aRelation.sourceUnit, sourceUnit, @"Bind relation set incorrect source unit and failed negative test.");
    XCTAssertFalse(aRelation.directionType == CREBindingRelationDirectionBothWays,  @"Bind relation set incorrect binding direction type. Negative test failed.");
    
    
}

-(void)testRemoveSourceUnit{
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    
    CREBindingUnit *sourceUnit = aRelation.bindingUnits [0];
    CREBindingUnit *bSourceUnit = aRelation.bindingUnits [1];
    
    [aRelation setSourceBindingUnit:sourceUnit];
    XCTAssertEqualObjects(aRelation.sourceUnit, sourceUnit, @"Bind relation set incorrect binding direction type.");
    
    [aRelation removeSourceUnit];
    XCTAssertNil(aRelation.sourceUnit, @"The relation must set the sourceUnit to nil.");
    XCTAssertTrue(aRelation.directionType == CREBindingRelationDirectionBothWays, @"Bind relation set incorrect binding direction type, after removing the source unit.");

    [aRelation setSourceBindingUnit:bSourceUnit];
    XCTAssertEqualObjects(aRelation.sourceUnit, bSourceUnit, @"Bind relation set incorrect binding direction type.");
    [aRelation removeSourceUnit];
    
    XCTAssertNil(aRelation.sourceUnit, @"The relation must set the sourceUnit to nil.");
    XCTAssertTrue(aRelation.directionType == CREBindingRelationDirectionBothWays, @"Bind relation set incorrect binding direction type, after removing the source unit.");

    for ( CREBindingUnit *aUnit in aRelation.bindingUnits)
    {
        XCTAssertNotNil(aUnit, @"Removing a source unit must not alter the bindingUnits array");
        XCTAssertNotNil(aUnit.boundObject, @"Removing a source unit must not alter the bindingUnits array");

    }
    
    
}

-(void)testSetSourceBindingBehavior{
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    
    CREBindingUnit *sourceUnit = aRelation.bindingUnits [0];
    CREBindingUnit *bSourceUnit = aRelation.bindingUnits [1];
    
    [aRelation setSourceBindingUnit:sourceUnit];

    
    CREBinder *aBinder = [CREBinder new];
    
    [aBinder addRelation:aRelation];
    
    [aDictionary setValue:bTestValue forKey:aProperty];
    
    XCTAssertEqualObjects(aDictionary[aProperty], bDictionary [bProperty], @"Failed binding in one-way relation type.");

    
    [bDictionary setValue:aTestValue forKey:bProperty];
    XCTAssertNotEqualObjects(aDictionary[aProperty], bDictionary [bProperty], @"Failed binding in one-way relation type. The read-only source object was modified.");
    
    [aRelation removeSourceUnit];
    [bDictionary setValue:aTestValue forKey:bProperty];
    XCTAssertEqualObjects(aDictionary[aProperty], bDictionary [bProperty], @"Removing source unit must lead to both way binding.");
    
    [aRelation setSourceBindingUnit:bSourceUnit];
    
    [aDictionary setValue:bTestValue forKey:aProperty];
    XCTAssertEqualObjects(aDictionary[aProperty], bDictionary [bProperty], @"Failed binding in one-way relation type. The read-only source object was modified.");
    
    
}


-(void)testMergeValue{
    
    CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    
    [aRelation mergeValue:bTestValue toTarget:aRelation.bindingUnits [0]];
    
    //test notEqual because the relation was not called "bind"
    XCTAssertNotEqualObjects(aDictionary[aProperty], bDictionary[bProperty], @"MergeValue interface call failed.");
    XCTAssertEqualObjects(aDictionary[aProperty], bTestValue, @"MergeValue failed to assign value.");
    
    aRelation = nil;
    
    CREBindRelation *bRelation = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty]
                                                               sourceObjects:@[aDictionary, bDictionary]];
    //test in the context 'bind' called
    [bRelation bind];
    
    [bRelation mergeValue:aTestValue toTarget:bRelation.bindingUnits [0]];
//    XCTAssertEqualObjects(aDictionary[aProperty], bDictionary[bProperty], @"MergeValue interface call failed.");
    XCTAssertEqualObjects(aDictionary[aProperty], aTestValue, @"MergeValue failed to assign value.");

    
    
    
}


@end
