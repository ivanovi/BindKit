 //
//  CREBinder.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREBinder.h"

@interface CREBinder(){
    
    NSMutableArray *tempPairsArray;
    
}

@end

@implementation CREBinder


#pragma mark - Public Methods

-(instancetype)initWithMapping:(NSDictionary *)mapDictionary{
    self = [super init];
    
    if (self) {
        
        tempPairsArray = [NSMutableArray new];
        [tempPairsArray addObject:mapDictionary];
        
        
       // _mappingDictionary = mapDictionary;
        
    }
    
    return self;
    
}


+(instancetype)binderWithMapping:(NSDictionary *)mapDictionary{
    
    return [[self alloc] initWithMapping:mapDictionary];
    
}


-(void)addPair:(NSDictionary *)objectsPair{
    NSAssert(objectsPair.count == 0,@"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:0]);
    
    
    if (![self didAddPair:objectsPair]) {
        
        [tempPairsArray addObject:objectsPair];
        
    }
  
    
}


-(void)bind{
    
    
    for (NSDictionary *objectsPair in tempPairsArray) {
        
        for (NSString * propertyName in objectsPair) {
            
            id sourceObject = objectsPair [propertyName];
            id value = [objectsPair [propertyName]  valueForKeyPath: propertyName];
            
            if (value)
            {
                
                [self observeValueForKeyPath:propertyName ofObject:sourceObject
                                      change:nil //against Liskov principle
                                     context:NULL];//wrong
            }
            
            [sourceObject addObserver:self forKeyPath:propertyName options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)context:nil];
            
            
        }
        
    }
    
}

-(void)bindPair:(NSArray *)pairArray{
    
    
}

-(NSArray*)pairs{
    
    if (tempPairsArray)
    {
        
        return [NSArray arrayWithArray:tempPairsArray];
        
    }
    return nil;
}

//-(void)bindWithSource:(id)source target:(id)target{
//    
//    
//}

#pragma mark - Private Methods


-(BOOL)didAddPair:(NSDictionary*)pair{
    
    for (NSDictionary * existindPairDictionary in tempPairsArray) {
        
        if ([existindPairDictionary isEqualToDictionary:pair]) {
            return YES;
        }
        
    }
    
    return NO;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSLog(@"value changed object %@", object);
    
    BOOL mergeBOOL = YES;
    id newValue = [object valueForKeyPath:keyPath];
    id targetObject = [self objectInPairWithBoundObject:object];
   
    
    if (_delegate)
    {
        
        if ([_delegate respondsToSelector:@selector(binder:shouldSetValue:forKeyPath:)])
        {
            mergeBOOL = [_delegate binder:self shouldSetValue:newValue forKeyPath:keyPath];
        }else
        {
            NSLog(@"Warnig %@", [NSError errorDescriptionForDomain:kCREBinderWarningsDomain code:1000]);
        }
        if (mergeBOOL)
        {
            
            if([_delegate respondsToSelector:@selector(binder:willSetValue:forKeyPath:inObject:)])
            {
                [_delegate binder:self willSetValue:newValue forKeyPath:keyPath inObject:object];
            }
            
        }
    } //end delegation
    
    
    if (mergeBOOL)
    {
        
        [self mergeValue:newValue toTarget:targetObject withKeyPath:keyPath];
        
    }
    
}

-(void)mergeValue:(id)value toTarget:(id)target withKeyPath:(NSString *)keyPath{
    
    
}


#pragma mark - Private methods

-(id)objectInPairWithBoundObject:(id)boundObject{
    
    //finds the object in a pair bound with the boundObject argument
    
    __block id returnValue = nil;
    
    for (NSDictionary *bindingPairDictionary in tempPairsArray)
    {
        

        [bindingPairDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
           
            if (! [obj isEqual:boundObject] ) {
                
                returnValue = obj;
                *stop = YES;
                
            }
            
        }];
        
    }
    
    return returnValue;
}

-(void)unbind{
    
    
}

-(void)dealloc{
    
    [self unbind];
    
}

@end
