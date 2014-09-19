//
//  BindKitValueTransformerTests.m
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
#import "CREBindTestHelper.h"
#import "CREValueTransformer.h"


@interface BindKitValueTransformerTests : BindKitTestCase{
    
    UIImage * testImage;
    NSData * imagePNGData;
    
    //CREBindTestHelper *helper;
}

@end

@implementation BindKitValueTransformerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    testImage = helper.testImage;
    imagePNGData = helper.testPNGImageData;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testValueTransformerCreation{
    id valueTransformer = [self createTestTransformerWithClassName:@"CREDataImageTransformer"];
    
    XCTAssert(valueTransformer, @"The ValueTransformer convinience/factory method failed to create transformer with existing class. In method %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([valueTransformer conformsToProtocol:@protocol(CREValueTransformerProtocol)], @"ValueTransform created non-conforming class. Unit test failed in %s", __PRETTY_FUNCTION__ );
    XCTAssertTrue([valueTransformer respondsToSelector:@selector(bindRelation:willModify:withValue:)], @"ValueTransformer does not implement the mandatory method bindRelation:willModify:withValue:. Unit test failed in %s", __PRETTY_FUNCTION__ );
    
    //negative
    XCTAssertThrows(  [CREValueTransformer transformerWithName:@"nonExistingClass"],  @"ValueTransformer creation factory allowed creation of non existent class.");
    

    
}

#pragma mark - Data to image transformer

-(void)testDataImageTransformation{
    id <CREValueTransformerProtocol> valueTransformer = [self createTestTransformerWithClassName:@"CREDataImageTransformer"];
    
    UIImage *returnedImage = [valueTransformer bindRelation:nil willModify:nil withValue:imagePNGData];
    
    XCTAssert(returnedImage, @"ValueTransformer returned nil. In %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([returnedImage isKindOfClass:[UIImage class] ], @"DataToImage transformer returned instance of non-image type. In %s", __PRETTY_FUNCTION__);
    

    XCTAssertThrows([valueTransformer bindRelation:nil willModify:nil withValue:@"s"], @"DataToImage transformer did not throw exception in %s", __PRETTY_FUNCTION__);
    
}

#pragma mark - Image to data transformer

-(void)testNegateTransformer{
    
     id <CREValueTransformerProtocol> valueTransformer = [self createTestTransformerWithClassName:@"CRENegateTransformer"];
    
    NSNumber *parameter = @1;
    NSNumber *returnedValueNum = [valueTransformer bindRelation:nil willModify:nil withValue:parameter];
    XCTAssert(returnedValueNum, @"ValueTransformer returned nil. In %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([parameter isEqualToNumber: [self normalizeNegatedValue:returnedValueNum] ], @"NegateTransformer failed to negate value. ");
    
    NSNumber *parameterBool = [NSNumber numberWithBool:YES];
    NSNumber *returnedValueBool = [valueTransformer bindRelation:nil willModify:nil withValue:parameterBool];
    XCTAssert(returnedValueBool, @"ValueTransformer returned nil. In %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([parameterBool isEqualToNumber: [self normalizeNegatedValue:returnedValueBool] ], @"NegateTransformer failed to negate value. ");
    
    
    XCTAssertThrows([valueTransformer bindRelation:nil willModify:nil withValue:@"i'm not an NSNumber"], @"NegateTransformer accepted a non-NSnumber value");
    
}

#pragma mark - Image to data transformer

-(void)testIsNilTransformer{
    
    id <CREValueTransformerProtocol> valueTransformer = [self createTestTransformerWithClassName:@"CREIsNilTransformer"];
    
    id objectNil = nil;
    
    NSNumber *returnedValue = [valueTransformer bindRelation:nil willModify:nil withValue:objectNil];
    XCTAssert(returnedValue, @"ValueTransformer returned nil. In %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(returnedValue.boolValue, @"IsNilTransformer returned wrong value %s", __PRETTY_FUNCTION__);
    
    objectNil = [NSNull null];
    
    returnedValue = [valueTransformer bindRelation:nil willModify:nil withValue:objectNil];
    
    XCTAssert(returnedValue, @"ValueTransformer returned nil. In %s", __PRETTY_FUNCTION__);
    XCTAssertTrue(!returnedValue.boolValue, @"IsNilTransformer returned wrong value %s", __PRETTY_FUNCTION__);
    
    XCTAssertTrue([returnedValue isKindOfClass:[NSNumber class]],@"NegateTransformer returned wrong type");
    
    
}

#pragma mark - Number to Date

-(void)testNumberDateTransformer{
    id <CREValueTransformerProtocol> valueTransformer = [self createTestTransformerWithClassName:@"CRENumberDateTransformer"];
    
    NSDate *nowDate = [NSDate date];
    
    id returnedValue = [valueTransformer bindRelation:nil willModify:nil withValue:@( [nowDate  timeIntervalSince1970] )];
    
    XCTAssert(returnedValue, @"ValueTransformer returned nil. In %s", __PRETTY_FUNCTION__);
    XCTAssertTrue([nowDate isEqualToDate:returnedValue], @"NumberToDate transformer returned wrong value" );
    
    NSDate *diffrentDate = [NSDate date];
    
    id returnedSecondValue = [valueTransformer bindRelation:nil willModify:nil withValue:@( [diffrentDate  timeIntervalSince1970] )];
    
    XCTAssertTrue(![nowDate isEqualToDate:returnedSecondValue],  @"NumberToDate transformer returned wrong value on negative test");
    XCTAssertThrows([valueTransformer bindRelation:nil willModify:nil withValue:@"i'm not an NSDate"], @"NegateTransformer accepted a non-NSnumber value");

}

#pragma mark - Support


-(id <CREValueTransformerProtocol>)createTestTransformerWithClassName:(NSString*)className{
    
    return [CREValueTransformer transformerWithName:className];
    
}

-(NSNumber*)normalizeNegatedValue:(NSNumber*)number{
    
    return [NSNumber numberWithInt: (number.intValue * -1  )  ];
    
}
@end
