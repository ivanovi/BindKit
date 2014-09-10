//
//  CRERemoteBindingTransaction.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRERemoteBindingTransaction.h"

@implementation CRERemoteBindingTransaction


//-(instancetype)initWithDictionary:(NSDictionary *)bindingDict{
//    self = [super initWithDictionary:bindingDict];
//    
//    if (self) {
//      
//     
//        if (bindingDict) {
//            
//        }
//      
//        
//    }
//    
//    return self;
//    
//}

-(instancetype)initWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray{
    self = [super initWithProperties:propertiesArray sourceObjects:objectsArray];
    
    if (self) {
        
        [self setSourceBindingUnit:self.bindingUnits[0] ];
        
        
    }
    
    return self;
}

//-(CREBindingTransactionDirection)directionType{
//    
//    return CREBindingTransactionDirectionOneWay;
//    
//}


@end
