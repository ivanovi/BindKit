//
//  CRESocialServicesRelation.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/17/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//


#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "CRESocialServicesRelation.h"


@implementation CRESocialServicesRelation




-(void)executeRequest:(id)request withCallBack:(void (^)(NSURLResponse *response,
                                                         NSData *data,
                                                         NSError *connectionError)) completionHandler{
    [self assertRequest:request];
    
    [(SLRequest*)request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        completionHandler (urlResponse,responseData,error);
        
    }];

    
    
}




@end
