//
//  CREBindingUnit.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/29/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREBindingUnit.h"

@implementation CREBindingUnit


-(instancetype)initWithDictionary:(NSDictionary *)bindingMappingDictionary{
    NSAssert(bindingMappingDictionary.count == 1, @"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:102]);
    self = [super init];
    
    if (self) {
        
        _boundObject = bindingMappingDictionary.allValues.lastObject;
        _boundObjectProperty = bindingMappingDictionary.allKeys.lastObject;
        
        
    }
    
    return self;
}


-(BOOL)isEqualToDictionary:(NSDictionary *)dictionary{
    
    
    __block BOOL comparisonResult = NO;
    __block void (^simpleStopBlock)(BOOL*, BOOL) = ^(BOOL*stop, BOOL compare){
        *stop = YES;
        compare = YES;
    };
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([key isEqual: _boundObjectProperty])
            simpleStopBlock(stop, comparisonResult);
        
        if ([obj isEqual: _boundObject])
            simpleStopBlock(stop, comparisonResult);
    
    }];
    
    return comparisonResult;
    
}
@end
