//
//  CREBindTestHelper.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/10/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

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
