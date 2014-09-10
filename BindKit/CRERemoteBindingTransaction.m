//
//  CRERemoteBindingTransaction.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRERemoteBindingTransaction.h"

@implementation CRERemoteBindingTransaction


-(instancetype)initWithDictionary:(NSDictionary *)bindingDict{
    self = [super initWithDictionary:bindingDict];
    
    if (self) {
      
     
        if (bindingDict) {
            
        }
      
        
    }
    
    return self;
    
}

-(CREBindingTransactionDirection)directionType{
    
    return CREBindingTransactionDirectionOneWay;
    
}


@end
