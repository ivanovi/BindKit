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
    
    NSMutableSet * holderSet;
    
}

@end

@implementation CREBindingTransaction

-(instancetype)init{
    self = [super init];
    
    if (self) {
        
        holderSet = [NSMutableSet new];
        _directionType = CREBindingTransactionDirectionBothWays;
    }
    
    return self;
}

-(instancetype)initWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray{
    self = [self init];
    
    if (self) {
        
        for (int i = 0 ; i < propertiesArray.count ; i++)
        {
            
            NSString *property = propertiesArray [i];
            id sourceObject = objectsArray [i];
            
            CREBindingUnit *aUnit = [[CREBindingUnit alloc] initWithDictionary:@{property : sourceObject}];
            
            [self addBindingUnit:aUnit];
            
            
        }
        
        
    }
    
    return self;
    
}

//-(instancetype)initWithDictionary:(NSDictionary *)bindingDict{
//    NSAssert(bindingDict, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
//    
//    self = [self init];
//    
//    if (self)
//    {
//        _directionType = CREBindingTransactionDirectionBothWays;
//        
//        for (NSString *key in bindingDict) {
//            
//            CREBindingUnit *newBindingUnit = [[CREBindingUnit alloc]initWithDictionary:@{key:bindingDict[key]}];
//            [self addBindingUnit:newBindingUnit];
//            
//        }
//        
//    }
//    
//    return self;
//    
//}

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

#pragma mark - Binding Units

- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict{

    CREBindingUnit *newBinderUnit = [self bindingUnitForDictionary:propertyTargetDict];
    
    if (!newBinderUnit)
    {
        
        newBinderUnit = [[CREBindingUnit alloc] initWithDictionary:propertyTargetDict];
        [holderSet addObject:newBinderUnit];
        [newBinderUnit setTransaction:self];

    
    }
    
    return newBinderUnit;
}

- (void)addBindingUnit:(CREBindingUnit*)subBindingUnit{
    
    if (![holderSet containsObject:subBindingUnit])
    {
        
        [holderSet addObject:subBindingUnit];
        [subBindingUnit setTransaction:self];
        
    }
    
}

-(void)addSourceBindingUnit:(CREBindingUnit *)sourceBindingUnit{
    
    [self addSourceBindingUnit:sourceBindingUnit];
    
    _directionType = CREBindingTransactionDirectionOneWay;
    sourceUnit = sourceBindingUnit;
    
}

-(NSDictionary*)propertyTargetRelationForProperty:(NSString *)property{
    
    return nil;
}

- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit{
 
    [holderSet removeObject:bindingUnit];
    
    if ([bindingUnit isEqual:sourceUnit]) {
        
        sourceUnit = nil;
        
    }
    
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

-(BOOL)containsUnit:(CREBindingUnit *)unit{
    
    return [holderSet containsObject:unit];
    
    
}

#pragma mark - Merge

-(void)mergeValue:(id)value toTarget:(CREBindingUnit *)target{
    
    NSAssert(value, @"Value in %s not set", __PRETTY_FUNCTION__);

    [target.boundObject setValue:value forKey:target.boundObjectProperty];
    
    
}


@end
