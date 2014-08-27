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
    NSAssert(objectsPair.count == 0,@"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorDomainSetup code:0]);
    
    
    if (![self didAddPair:objectsPair]) {
        
        [tempPairsArray addObject:objectsPair];
        
    }
  
    
}


-(void)bind{
    
    
    for (NSDictionary *objectsPair in tempPairsArray) {
        
        
        for (NSString * propertyName in objectsPair) {
            
            id targetObject = objectsPair [propertyName]; // wrong
            id sourceObject = objectsPair [propertyName]; // wrong
            
            id value = [objectsPair [propertyName]  valueForKeyPath: propertyName];
            
            if (value) {
                
                [self observeValueForKeyPath:propertyName ofObject:sourceObject change:[NSDictionary new] context:NULL];//wrong
                
            }
            
            
            
        }

        
        
        
    }
    
    
    
}

-(void)bindPair:(NSArray *)pairArray{
    
    
}

-(NSArray*)pairs{
    
    if (tempPairsArray) {
        
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
    
    
    
}


@end
