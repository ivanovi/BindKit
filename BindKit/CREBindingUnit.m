//
//  CREBindingUnit.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/29/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREBindingUnit.h"

@implementation CREBindingUnit

//TODO: Re
-(instancetype)initWithDictionary:(NSDictionary *)bindingMappingDictionary{
    NSAssert(bindingMappingDictionary.count == 1, @"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:102]);

#ifndef DEBUG
    
    NSAssert([bindingMappingDictionary.allValues.lastObject respondsToSelector:NSSelectorFromString(bindingMappingDictionary.allKeys.lastObject;)],
             @"%s %@", __PRETTY_FUNCTION__ , [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain
                                                                           code:103]);
#endif

    self = [super init];
    if (self) {
    
        if ([_boundObject respondsToSelector:NSSelectorFromString(_boundObjectProperty)]) {
            
            _boundObject = bindingMappingDictionary.allValues.lastObject;
            _boundObjectProperty = bindingMappingDictionary.allKeys.lastObject;
            
        }
        
    }
    
    return self;
}




-(BOOL)compareWithDict:(NSDictionary *)dictionary{
    
    __block BOOL comparisonResult = NO;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([key isEqual: _boundObjectProperty] ||
            [obj isEqual: _boundObject])
            comparisonResult = YES;
        
    }];
    
    return comparisonResult;
    
}
@end
