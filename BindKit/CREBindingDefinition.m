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
    
    NSMutableSet *holderSet;
    
}
@end

@implementation CREBindingDefinition


-(instancetype)init{
    self = [super init];
    
    if (self) {
        
        holderSet = [NSMutableSet new];
    }
    
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)bindingDict{
    NSAssert(bindingDict, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    self = [self init];
    
    if (self) {
    
        CREBindingUnit *newBindingUnit = [[CREBindingUnit alloc]initWithDictionary:bindingDict];
        [holderSet addObject: newBindingUnit];
        
        
    }
    
    return self;
    
}

#pragma mark - Getters of readonly objects

-(NSSet*)boundObjects{

    NSAssert(holderSet, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    return [self allBinderUnitValuesWithKey:@"boundObject"];

}

-(NSSet*)keys{
    
    NSAssert(holderSet, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    return [self allBinderUnitValuesWithKey:@"boundObjectProperty"];

    
}


- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict{

    CREBindingUnit *newBinderUnit = [[CREBindingUnit alloc] initWithDictionary:propertyTargetDict];
    
    if (![self unitWithDictionaryWasAdded:propertyTargetDict]) {
        
        
    }
    
    return newBinderUnit;
}

-(NSDictionary*)propertyTargetRelationForProperty:(NSString *)property{
    
    return nil;
}

-(void)removePropertyTargetRelation:(NSDictionary *)propertyTargetDict{
 
    
}

-(BOOL)unitWithDictionaryWasAdded:(NSDictionary*)prospectDictionary{
    

    
    return NO;
}


-(NSSet*)allBinderUnitValuesWithKey:(NSString*)binderUnitKey{
    
    
    NSMutableSet *objectsSet = nil;
    
    for (CREBindingUnit *aBinderUnit in holderSet) {
        
        [objectsSet addObject:[aBinderUnit valueForKey:binderUnitKey] ];
        
    }
    
    return objectsSet;
    
}
@end
