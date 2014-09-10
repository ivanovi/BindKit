//
//  CRERemoteBinder.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/10/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRERemoteBinder.h"


@implementation CRERemoteBinder


-(CREBindingTransaction*)createTransactionWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray{
    
    return [[CRERemoteBindingTransaction alloc]initWithProperties:propertiesArray sourceObjects:objectsArray];
        
}


@end
