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


@interface BindKitTests : XCTestCase  {
 
    NSDictionary * aDictionary, *bDictionary;
    NSString *aTestValue, *bTestValue, *cTestValue;
    NSString *aProperty, *bProperty;
    
    
}

@end

@implementation BindKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    aDictionary = [self baseDictionaryWithName:@"aDictionary"];
    bDictionary = [self baseDictionaryWithName:@"bDictionary"];

    [self baseTestValues];
    [self baseProperties];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testBaseBinding{
    
    
    CREBinder *newBinder = [CREBinder binderWithMapping:@{aProperty:aDictionary,
                                                          bProperty:bDictionary}];
    [newBinder bind];
    
    [aDictionary setValue:aTestValue forKey:aProperty];
    
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);

    [aDictionary setValue:bTestValue forKey:aProperty];
    
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);

    [bDictionary setValue:cTestValue forKey:bProperty];
    
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);

    
    NSLog(@"dictionary A %@ dictionary B %@", aDictionary, bDictionary);
    
}

-(void)testBaseBindingNegative{
    
    CREBinder *newBinder = [CREBinder binderWithMapping:@{aProperty:aDictionary,
                                                          bProperty:bDictionary}];
    [newBinder bind];

    [aDictionary setValue:aTestValue forKey:aProperty];
    
    XCTAssertEqualObjects(aDictionary [aProperty], bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);
    
    [aDictionary setValue:bTestValue forKey:aProperty];
    
    XCTAssertNotEqualObjects(aTestValue , bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);

    [aDictionary setValue:cTestValue forKey:aProperty];

    XCTAssertNotEqualObjects(bTestValue , bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);
    XCTAssertNotEqualObjects(aTestValue , bDictionary [bProperty], @"Failed test %s", __PRETTY_FUNCTION__);


}

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
    XCTAssert([testUnit.boundObject isEqual: aDictionary], @"BindingUnit property setup failed at initialization");
    XCTAssert([testUnit.boundObjectProperty isEqual: aProperty], @"BindingUnit property setup failed at initialization");
    

    
}

-(void)testBindingUnitInitializationNegative{
    
    UILabel *aLabel = [UILabel new];
    CREBindingUnit *testUnit = [[CREBindingUnit alloc]initWithDictionary:@{aProperty:aLabel}];
    
    XCTAssert( (!testUnit.boundObjectProperty && !testUnit.boundObject), @"BindingUnit initializaiton negative test failed");
    
}





#pragma mark - Support

-(NSDictionary*)baseDictionaryWithName:(NSString*)name{
    
    return [NSDictionary dictionaryWithObject:name
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
    
}



//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
