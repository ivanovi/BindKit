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
    
    NSMutableArray * holderSet;
    
}

@end

@implementation CREBindingTransaction

-(instancetype)init{
    self = [super init];
    
    if (self) {
        
        holderSet = [NSMutableArray new];
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




-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (_isLocked) //protect against infinite loop when both ways binding
    {
        NSLog(@"Binder is locked. Discontinuing loop.");
        return;
        
    }
    // NSLog(@"value changed object %@", object);
    
    
    
    CREBindingUnit *bindingUnit = (__bridge CREBindingUnit*)context;
    NSArray *peerUnitSet = bindingUnit.transaction.bindingUnits;
    
    
    for ( CREBindingUnit *notifyUnit in peerUnitSet) {
        
        if ([notifyUnit isEqual:bindingUnit]) {
            continue;
        }
        
        
        BOOL mergeBOOL = YES;
        id newValue = [object valueForKeyPath:keyPath];
        //        id targetObject =  notifyUnit.boundObject; // [self objectInPairWithBoundObject:object mapKeys:NO];
        //        id targetKey =  notifyUnit.boundObjectProperty; //[self objectInPairWithBoundObject:keyPath mapKeys:YES];
        
        if (_delegate) //delegation
        {
            
            if ([_delegate respondsToSelector:@selector(bindTransaction:shouldSetValue:forKeyPath:)])
            {
                mergeBOOL = [_delegate bindTransaction:self shouldSetValue:newValue forKeyPath:keyPath];
            }else
            {
                NSLog(@"Warnig %@", [NSError errorDescriptionForDomain:kCREBinderWarningsDomain code:1000]);
            }
            if (mergeBOOL)
            {
                
                if([_delegate respondsToSelector:@selector(bindTransaction:willSetValue:forKeyPath:inObject:)])
                {
                    [_delegate bindTransaction:self willSetValue:newValue forKeyPath:keyPath inObject:object];
                }
                
            }
        } //end delegation
        
        
        if (mergeBOOL)
        {
            _isLocked = YES;
                [self mergeValue:newValue toTarget:notifyUnit];
            _isLocked = NO;
            
        }
        
        
        
    }
    
}


-(void)handleInitialValue:(id)value unit:(CREBindingUnit*)unit{
    
    NSString *properyName = unit.boundObjectProperty;
    id sourceObject = unit.boundObject;
    void *context = (__bridge void *)unit;
    
    if (value)
    {
        
        [self observeValueForKeyPath:properyName ofObject:sourceObject
                              change:nil context:context];
        
    }else{
        
        if ([self.placeholder respondsToSelector:@selector(bindTransaction:requiresPlaceholderValuesForUnit:)]) {
            
            
            value = [self.placeholder bindTransaction:self requiresPlaceholderValuesForUnit:unit];
            
            [self observeValueForKeyPath:properyName ofObject:sourceObject
                                  change:nil context:context];
        }
        
    }
    
    
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

-(NSArray*)bindingUnits{
    
    NSAssert(holderSet, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    return [NSArray arrayWithArray:holderSet];
    
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

-(void)setSourceBindingUnit:(CREBindingUnit *)sourceBindingUnit{
    
   // [self addSourceBindingUnit:sourceBindingUnit];
    
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
    
    if ([_valueTransformer respondsToSelector:@selector(bindTransaction:willModify:withValue:)]) {
        
        value = [_valueTransformer bindTransaction:self willModify:target withValue:value];
        
    }
    
    
    NSAssert(value, @"__FIX Value in %s not set", __PRETTY_FUNCTION__);

    [target.boundObject setValue:value forKeyPath:target.boundObjectProperty];
    
    
}


@end
