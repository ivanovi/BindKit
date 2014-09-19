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

- (void)testBindingDefintionInit{
    
    CREBindRelation *aDefinition = [[CREBindRelation alloc] initWithProperties:@[aProperty, bProperty] sourceObjects:@[aDictionary, bDictionary]];
    
    for (CREBindingUnit *aBindingUnit in aDefinition.bindingUnits)
    {
        
        XCTAssertTrue( [aTestMappingDictionary [aBindingUnit.boundObjectProperty] isEqual: aBindingUnit.boundObject],
                      @"BindingDefinition test failed");
        
    }
    
}
//TODO: add assertion + add unit duplication check in class

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


@end
