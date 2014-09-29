//
//  CREBindRelation.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
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



#import "CREBindRelation.h"
#import "NSError+BinderKit.h"
#import "CREBindingUnit.h"


@interface CREBindRelation(){
    
    NSMutableArray * holderArray;
    
}

@end

@implementation CREBindRelation

-(instancetype)init{
    self = [super init];
    
    if (self) {
        
        holderArray = [NSMutableArray new];
        
        _directionType = CREBindingRelationDirectionBothWays;
        _isBound = NO;
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
            
            CREBindingUnit *aUnit = [[CREBindingUnit alloc]initWithObject:sourceObject property:property];
            
            [self addBindingUnit:aUnit];
            
            
        }
        
        
    }
    
    NSAssert(holderArray.count > 0, @"%s %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:101]);
    
    return self;
    
}





-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
   if (self.isLocked) //protect against infinite loop when both ways binding
    {
        return;
    }

    CREBindingUnit *bindingUnit = (__bridge CREBindingUnit*)context;
    NSArray *peerUnitSet = bindingUnit.relation.bindingUnits;
    BOOL mergeBOOL = YES;
    
    for ( CREBindingUnit *notifyUnit in peerUnitSet) {
        
        id newValue = [object valueForKeyPath:keyPath];
        
        if ([notifyUnit isEqual:bindingUnit] ||
            [notifyUnit.value isEqual:newValue] ||
            !newValue){
            
            continue;
            
        }
        
        if (_delegate) //delegation
        {
            
            if ([_delegate respondsToSelector:@selector(bindRelation:shouldSetValue:forKeyPath:)])
            {
                mergeBOOL = [_delegate bindRelation:self shouldSetValue:newValue forKeyPath:keyPath];
            }else
            {
                NSLog(@"Warnig %@ for %@", [NSError errorDescriptionForDomain:kCREBinderWarningsDomain code:1000],
                      NSStringFromSelector( @selector(bindRelation:shouldSetValue:forKeyPath:)));
            }
            if (mergeBOOL)
            {
                
                if([_delegate respondsToSelector:@selector(bindRelation:willSetValue:forKeyPath:inObject:)])
                {
                    [_delegate bindRelation:self willSetValue:newValue forKeyPath:keyPath inObject:object];
                }
                
            }
        } //end delegation
        
        if (mergeBOOL)
        {
            
            [self mergeValue:newValue toTarget:notifyUnit];
            
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
        
        if ([self.placeholder respondsToSelector:@selector(bindRelation:requiresPlaceholderValuesForUnit:)])
        {
            
            
            value = [self.placeholder bindRelation:self requiresPlaceholderValuesForUnit:unit];
            [self observeValueForKeyPath:properyName ofObject:sourceObject
                                  change:nil context:context];
        }
        
    }
    
    
}


#pragma mark - Getters of readonly objects

-(NSSet*)boundObjects{

    
    return [self allBinderUnitValuesWithKey:@"boundObject"];

}

-(NSSet*)keys{

    
    return [self allBinderUnitValuesWithKey:@"boundObjectProperty"];
    
}

-(NSArray*)bindingUnits{
    
    
    return [NSArray arrayWithArray:holderArray];
    
}

#pragma mark - Binding Units

- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict{

    CREBindingUnit *newBinderUnit = [self bindingUnitForDictionary:propertyTargetDict];
    
    if (!newBinderUnit)
    {
        
        newBinderUnit = [[CREBindingUnit alloc] initWithObject:propertyTargetDict.allValues.lastObject property:propertyTargetDict.allKeys.lastObject];
        [holderArray addObject:newBinderUnit];
        [newBinderUnit setRelation:self];

    
    }
    
    return newBinderUnit;
}

- (void)addBindingUnit:(CREBindingUnit*)subBindingUnit{
    
    if (![holderArray containsObject:subBindingUnit])
    {
        
        [holderArray addObject:subBindingUnit];
        [subBindingUnit setRelation:self];
        
    }
    
}

#pragma mark - Source Unit accessors



-(void)setSourceBindingUnit:(CREBindingUnit *)sourceBindingUnit{
    
    NSAssert([holderArray containsObject:sourceBindingUnit], @"The sourceUnit %@ failed to be set as a source in bindRelation because it is not part of the relation. %@", sourceUnit, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:109]);
    
    BOOL wasBound = _isBound;

    [self unbind];

        _directionType = CREBindingRelationDirectionOneWay;
        sourceUnit = sourceBindingUnit;
    
    if (wasBound)
        [self bind];
    
}

-(CREBindingUnit*)sourceUnit{
    
    return sourceUnit;
    
}

-(void)removeSourceUnit{
    BOOL wasBound = _isBound;

    [self unbind];
    
        _directionType = CREBindingRelationDirectionBothWays;
        sourceUnit = nil;
    
    if (wasBound)
        [self bind];
    
}

//
//-(NSDictionary*)propertyTargetRelationForProperty:(NSString *)property{
//    
//    return nil;
//}

- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit{
 
    [holderArray removeObject:bindingUnit];
    
    if ([bindingUnit isEqual:sourceUnit])
    {
        
        sourceUnit = nil;
        
    }
    
}

-(CREBindingUnit*)bindingUnitForDictionary:(NSDictionary*)prospectDictionary{
    
    CREBindingUnit *aUnit = nil;
    
    for (CREBindingUnit *aBinderUnit in holderArray)
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
    
    for (CREBindingUnit *aBinderUnit in holderArray)
    {
        
        [objectsSet addObject:[aBinderUnit valueForKey:binderUnitKey] ];
        
    }
    
    return objectsSet;
    
}

-(BOOL)containsUnit:(CREBindingUnit *)unit{
    
    return [holderArray containsObject:unit];
    
    
}

#pragma mark - Merge

-(void)mergeValue:(id)value toTarget:(CREBindingUnit *)target{
    
    if ([_valueTransformer respondsToSelector:@selector(bindRelation:willModify:withValue:)]) {
        
        value = [_valueTransformer bindRelation:self willModify:target withValue:value];
        
    }
    
   // NSLog(@"setting value %@ in target %@", value, target);
    
    if (value)
    {
        
        
        [target setValue:value];
        
         //   [target.boundObject setValue:value forKeyPath:target.boundObjectProperty];
        
    }else
    {
        
        NSLog(@"Warnining in %s. %@", __PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderWarningsDomain code:1001]);
        
    }
    
}

#pragma mark - Bind protocol

-(void)bind{
    
    if (_isBound)
        return;
    
    if (self.directionType == CREBindingRelationDirectionOneWay)
    {
        
        [self bindWithSource:self.sourceUnit];
        return;
    }
    
    NSArray *transactionUnitSet = self.bindingUnits;
    
    for (CREBindingUnit *aUnit in transactionUnitSet)
    {
        
        [self bindWithSource:aUnit];
        
    }
    
    _isBound = YES;

}

-(void)unbind{
    
    if (!_isBound)
        return;
    
    if (self.directionType == CREBindingRelationDirectionOneWay)
    {
        
        [self unbindWithSource:self.sourceUnit];
        return;
        
    }
    
    for ( CREBindingUnit *unit in self.bindingUnits )
    {
        
        [unit.boundObject removeObserver:self forKeyPath:unit.boundObjectProperty];
        
    }
    
    _isBound = NO;

}

-(void)bindWithSource:(CREBindingUnit*)unit{
    
    NSString *sourceKeyPath = unit.boundObjectProperty;
    
    id sourceObject = unit.boundObject;
    id sourceValue = [sourceObject valueForKeyPath:sourceKeyPath];
    
    [self handleInitialValue:sourceValue unit:unit];
    
    [sourceObject addObserver:self forKeyPath:sourceKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void *)unit];
    
    _isBound = YES;
    
}

-(void)unbindWithSource:(CREBindingUnit*)unit{
    
    [unit.boundObject removeObserver:self forKeyPath:unit.boundObjectProperty];
    _isBound = NO;
}

-(void)unlock{
    
    for(CREBindingUnit *aUnit in holderArray)
    {
        
        [aUnit unlock];
        
    }
    
    
}


-(BOOL)isLocked{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isLocked == YES"];
    NSArray *lockedUnits = [holderArray filteredArrayUsingPredicate:predicate];
    
    if ( (lockedUnits.count - 1) == holderArray.count)
    {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

@end
