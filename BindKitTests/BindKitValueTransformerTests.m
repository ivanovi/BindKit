//
//  BindKitValueTransformerTests.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/18/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BindKitTestCase.h"
#import "CREBindTestHelper.h"


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


@end
