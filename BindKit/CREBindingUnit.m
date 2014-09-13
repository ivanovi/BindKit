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

        if (![_boundObject isKindOfClass:[NSDictionary class]]) { //unit tests use dictionary
            
           //TODO: Introspect keypath
            
            
//            NSAssert([_boundObject respondsToSelector:NSSelectorFromString(_boundObjectProperty)],
//                     @"%s %@", __PRETTY_FUNCTION__ , [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain
//                                                                                   code:103]);
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

-(id)value{
    
    return [_boundObject valueForKeyPath:(NSString*)_boundObjectProperty];
    
}
@end
