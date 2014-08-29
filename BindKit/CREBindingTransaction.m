//
//  CREBindingDefinition.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREBindingTransaction.h"
#import "NSError+BinderKit.h"

@interface CREBindingTransaction(){
    
    NSMutableSet *holderSet;
    
}
@end

@implementation CREBindingTransaction


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
    
    if (self)
    {
        
        for (NSString *key in bindingDict) {
            
            CREBindingUnit *newBindingUnit = [[CREBindingUnit alloc]initWithDictionary:@{key:bindingDict[key]}];
            [holderSet addObject: newBindingUnit];
            
        }
        
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

-(NSSet*)bindingUnits{
    
    NSAssert(holderSet, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    return [NSSet setWithSet:holderSet];
    
}

- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict{

    CREBindingUnit *newBinderUnit = [self bindingUnitForDictionary:propertyTargetDict];
    
    if (!newBinderUnit)
    {
        
        newBinderUnit = [[CREBindingUnit alloc] initWithDictionary:propertyTargetDict];
        [holderSet addObject:newBinderUnit];
    
    }
    
    return newBinderUnit;
}

-(NSDictionary*)propertyTargetRelationForProperty:(NSString *)property{
    
    return nil;
}

- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit{
 
    [holderSet removeObject:bindingUnit];
    
}

-(CREBindingUnit*)bindingUnitForDictionary:(NSDictionary*)prospectDictionary{
    
    CREBindingUnit *aUnit = nil;
    
    for (CREBindingUnit *aBinderUnit in holderSet)
    {
        
        if ([aBinderUnit compareWithDict:prospectDictionary])
        {
            aUnit = aBinderUnit;
            break;
        }
        
    }
    
    return aUnit;
}


-(NSSet*)allBinderUnitValuesWithKey:(NSString*)binderUnitKey{
    
    
    NSMutableSet *objectsSet = nil;
    
    for (CREBindingUnit *aBinderUnit in holderSet) {
        
        [objectsSet addObject:[aBinderUnit valueForKey:binderUnitKey] ];
        
    }
    
    return objectsSet;
    
}
@end
