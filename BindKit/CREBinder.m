 //
//  CREBinder.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREBinder.h"

@interface CREBinder(){
    
    NSMutableArray *transactionsArray;
    
}

@end

@implementation CREBinder


#pragma mark - Public Methods
//
//-(instancetype)initWithMapping:(NSDictionary *)mapDictionary{
//    self = [super init];
//    
//    if (self)
//    {
//        
//        transactionsArray = [NSMutableArray new];
//        
//        CREBindingTransaction *aTransaction = [self createTransactionWithMapping:mapDictionary];
//        [transactionsArray addObject:aTransaction];
//        
//        _isLocked = NO;
//        
//    }
//    
//    return self;
//    
//}
//
//
//+(instancetype)binderWithMapping:(NSDictionary *)mapDictionary{
//    
//    return [[self alloc] initWithMapping:mapDictionary];
//    
//}


+(instancetype)binderWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray{
    
    return [[self alloc]initWithProperties:propertiesArray sourceObjects:objectsArray];
}


-(instancetype)initWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray{
    
    NSAssert(propertiesArray, @"Properties must be passed as an array. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:104]);
    NSAssert(objectsArray, @"Objects must be passed as an array. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:104]);
    NSAssert(propertiesArray.count == objectsArray.count, @"Properties' array count is different from the objects' array count. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:104]);
    
    self = [super init];
    
    if (self)
    {
        transactionsArray = [NSMutableArray new];
        CREBindingTransaction *initialTransaction = [self createTransactionWithProperties:propertiesArray sourceObjects:objectsArray];
        
        [transactionsArray addObject:initialTransaction];
        
//        for (int i = 0 ; i < propertiesArray.count ; i ++) {
//            
//            id sourceObject = objectsArray [i] ;
//            NSString * propertyName = propertiesArray [i];
//            
//            if (![sourceObject isKindOfClass:[NSDictionary class]]) {
//                NSAssert([sourceObject respondsToSelector:NSSelectorFromString(propertyName)], @"Source object does not respond to matched property. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:104]);
//            }
//            
//            
//
//            
//            CREBindingUnit *aUnit = [[CREBindingUnit alloc] initWithDictionary:@{ propertyName : sourceObject }];
//            [initialTransaction addBindingUnit:aUnit];
//            
//        }
        
        
    }
    
    return self;
}


-(CREBindingTransaction*)createTransactionWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray{
    
    if (!propertiesArray || !objectsArray) {
        
        return [CREBindingTransaction new];
        
    }
    
    return [[CREBindingTransaction alloc] initWithProperties:propertiesArray sourceObjects:objectsArray];
    
}


#pragma mark - Managing composites / child relations
//
//-(CREBindingTransaction*)addPair:(NSDictionary *)objectsPair to {
//    NSAssert(objectsPair.count == 1,@"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:100]);
//    
//    
//    if (![self didAddPair:objectsPair])
//    {
//        
////        [tempPairsArray addObject:objectsPair];
//        
//        
//        
//        
//    }
//  
//    return nil;
//}


-(void)bind{
    
    for (CREBindingTransaction *aTransaction in transactionsArray) {
        
        NSArray *transactionUnitSet = aTransaction.bindingUnits;
        
        for (CREBindingUnit *aUnit in transactionUnitSet) {
            
            NSString *propertyName = aUnit.boundObjectProperty;
            void *context = (__bridge void *)aUnit;
            
            id sourceObject = aUnit.boundObject;
            id value = [sourceObject valueForKey:propertyName];
            
            
            if (value)
            {
                
                [self observeValueForKeyPath:propertyName ofObject:sourceObject
                                      change:nil context:context];
                
            }
            
            [sourceObject addObserver:self forKeyPath:propertyName
                              options:NSKeyValueObservingOptionNew context:context];
            
        }
    }
    
    
    for (CREBinder *subBinder in _childBinders)
    {
        
        [subBinder bind];
        
    }
}

-(void)bindPair:(NSArray *)pairArray{
    
    
}

-(NSArray*)transactions{
    
    if (transactionsArray)
    {
        
        return [NSArray arrayWithArray:transactionsArray];
        
    }
    return nil;
}

//-(void)bindWithSource:(id)source target:(id)target{
//    
//    
//}

#pragma mark - Private Methods


//-(BOOL)didAddPair:(NSDictionary*)pair{
//    
////    for (NSDictionary * existindPairDictionary in tempPairsArray)
////    {
////        
////        if ([existindPairDictionary isEqualToDictionary:pair])
////        {
////            return YES;
////        }
////        
////    }
////    
////    return NO;
//
//
//
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
            _isLocked = YES;
                [self mergeValue:newValue toTarget:notifyUnit];
            _isLocked = NO;
            
        }

        
        
    }
    
    
}

-(void)mergeValue:(id)value toTarget:(CREBindingUnit*)target{
    
    if (value)
    {
        
        [target.transaction mergeValue:value toTarget:target];
            
    }
    
}

-(void)unbind{
    
//    for (NSDictionary * objectsPair in tempPairsArray) {
//        
//        for (NSString * propertyName in objectsPair) {
//            
//            id sourceObject = objectsPair [propertyName];
//            [sourceObject removeObserver:self forKeyPath:propertyName];
//            
//        }
//
//        
//    }
    
    for (CREBindingTransaction *transaction in transactionsArray) {
        
        for ( CREBindingUnit *unit in transaction.bindingUnits ) {
            
            [unit.boundObject removeObserver:self forKeyPath:unit.boundObjectProperty];
            
        }
        
        
    }
    
    
    for (CREBinder *subBinder in _childBinders)
    {
        
        [subBinder unbind];
        
    }
    
}



#pragma mark - Private methods

-(id)objectInPairWithBoundObject:(id)boundObject mapKeys:(BOOL)shouldMapKey{
    
    //finds the object or a key in a pair bound with the boundObject argument
    
    __block id returnValue = nil;
    
    for (NSDictionary *bindingPairDictionary in transactionsArray)
    {

        [bindingPairDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
           
            id compareObject = obj;
            if (shouldMapKey) {
                
                compareObject = key;
                
            }
            
            if (! [compareObject isEqual:boundObject] ) {
                
                returnValue = compareObject;
                *stop = YES;
                
            }

        }];
        
    }
    
    return returnValue;
}


-(void)dealloc{
    
    [self unbind];
    
}

@end
