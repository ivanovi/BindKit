//
//  CRERemoteBinder.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/10/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRERemoteBinder.h"
#import "CRERemoteBindingTransaction.h"

@implementation CRERemoteBinder


-(CREBindingTransaction*)createTransactionWithMapping:(NSDictionary *)mappingDict{
    
    return [[CRERemoteBindingTransaction alloc]initWithDictionary:mappingDict];
        
}


@end
