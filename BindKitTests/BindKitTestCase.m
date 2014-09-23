//
//  BindKitTestCase.m
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

#import "BindKitTestCase.h"

@interface BindKitTestCase(){
    
    BOOL didRunSetup;
    
}

@end

@implementation BindKitTestCase



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
        
        didRunSetup = YES;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



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
    
    XCTAssertEqualObjects(oneUnit.boundObject, secondUnit.boundObject,  @"Failed addinig bindingUnit; boundObjects are not equal." );
    XCTAssertEqualObjects(oneUnit.boundObjectProperty, secondUnit.boundObjectProperty,  @"Failed addinig bindingUnit ; boundObjectProperty are not equal." );

    
}


@end
