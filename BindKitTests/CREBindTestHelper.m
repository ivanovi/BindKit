//
//  CREBindTestHelper.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/10/14.
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



#import "CREBindTestHelper.h"

@interface CREBindTestHelper(){
    
    BOOL isRemote;
}

@end

@implementation CREBindTestHelper


-(instancetype)init{
    self = [super init];
    
    if (self) {
        isRemote = NO;
        [self initializeValues];
    }
    
    return self;
    
}

-(instancetype)initForRemoteTests{
    self = [super init];
    
    if (self) {
        
        isRemote = YES;
        [self initializeValues];
        
    }
    
    return self;
    
}


-(void)initializeValues{
    
    _aDictionary = [self baseDictionaryWithName:@"aDictionary"];
    _bDictionary = [self baseDictionaryWithName:@"bDictionary"];
    _cDictionary = [self baseDictionaryWithName:@"cDictionary"];
    
    [self baseTestValues];
    [self baseProperties];
    
    _aTestMappingDictionary = @{_aProperty:_aDictionary,
                               _bProperty:_bDictionary};
    
    
}

-(NSDictionary*)baseDictionaryWithName:(NSString*)name{
    
    return [NSMutableDictionary dictionaryWithObject:name
                                              forKey:@"name"];
}

-(void)baseTestValues{
    
    _aTestValue = !isRemote ? @"aTest" : @"http://jsonplaceholder.typicode.com/posts";
    _bTestValue = @"bTest";
    _cTestValue = @"cTest";
    
}

-(void)baseProperties{
    
    _aProperty = @"propertyA";
    _bProperty = @"propertyB";
    _cProperty = @"propertyC";
    
}




@end
