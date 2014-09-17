//
//  CRESocialServicesTransaction.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/17/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRESocialServicesTransaction.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation CRESocialServicesTransaction



-(void)mergeValue:(id)value toTarget:(CREBindingUnit *)target{
    
    [self assertSource];
    
    if ([self.valueTransformer respondsToSelector:@selector(bindTransaction:willModify:withValue:)]) {
        
        value = [self.valueTransformer bindTransaction:self willModify:target withValue:value];
        
    }
    
    if (![target isEqual:sourceUnit])
    {
        
        NSURLRequest *request = [self createRequest:sourceUnit.value];
        
        [self executeRequest:request withCallBack:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            id newValue = nil;
            
            if (!connectionError) {
                
                newValue = [self handleResponse:data urlResponse:response targetUnit:target];
                NSAssert(newValue, @"__FIX no newValue");
                
                NSLog(@"image received %@", sourceUnit.value);
                
                [self setValue:newValue forObject:target.boundObject withKeypath:target.boundObjectProperty];
                
            }else{
                //handle error
                
                NSLog(@"received ERROR response with value set %@ url %@", [connectionError localizedDescription], sourceUnit.value);
                
            }
            
            if (self.callBack) {
                
                self.callBack(newValue, target, connectionError);
                
            }
            
            
        }];
        
        
        
    }
    
}

-(void)executeRequest:(id)request withCallBack:(void (^)(NSURLResponse *response,
                                                         NSData *data,
                                                         NSError *connectionError)) completionHandler{
    [self assertRequest:request];
    
    [(SLRequest*)request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        completionHandler (urlResponse,responseData,error);
        
    }];

    
    
}




@end
