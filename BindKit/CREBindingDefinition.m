//
//  CREBindingDefinition.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREBindingDefinition.h"
#import "NSError+BinderKit.h"

@interface CREBindingDefinition(){
    
    NSMutableDictionary *holdingDictionary;
    
}
@end

@implementation CREBindingDefinition


-(instancetype)init{
    self = [super init];
    
    if (self) {
        
        holdingDictionary = [NSMutableDictionary new];
    }
    
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)bindingDict{
    NSAssert(bindingDict, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    self = [super init];
    
    if (self) {
    
        holdingDictionary = [NSMutableDictionary dictionaryWithDictionary:bindingDict];
        
    }
    
    return self;
    
}

#pragma mark - Getters of readonly objects

-(NSSet*)boundObjects{

    NSAssert(holdingDictionary, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    return [NSSet setWithArray:holdingDictionary.allValues];

}

-(NSSet*)keys{
    
    NSAssert(holdingDictionary, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    return [NSSet setWithArray:holdingDictionary.allKeys];
    
}

-(void)addPropertyTargetRelation:(NSDictionary *)propertyTargetDict{
    
    [holdingDictionary setValuesForKeysWithDictionary:propertyTargetDict];
    
}

-(NSDictionary*)propertyTargetRelationForProperty:(NSString *)property{
    
    return @{property: holdingDictionary [property] };
    
}

-(void)removePropertyTargetRelation:(NSDictionary *)propertyTargetDict{
    
    [holdingDictionary removeObjectForKey:propertyTargetDict];
    
}
@end
