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

-(id)requestWithRequest:(id)request{
    
    if (self.requestFactory) {
        
        return self.remoteRequest;
        
    }
    
    [self assertRequest:request];
    
    
    SLRequest *initialRequest = request;
    
    return [SLRequest requestForServiceType:[self resolveAcountServiceToSLserviceWithAccount:initialRequest.account.accountType.identifier]
                              requestMethod:initialRequest.requestMethod
                                        URL:urlContainer
                                 parameters:initialRequest.parameters];
}

-(NSString*)resolveAcountServiceToSLserviceWithAccount:(NSString*)accountIdentifier{
    
    if ([accountIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
        
        return SLServiceTypeFacebook;
        
    }else if ([accountIdentifier isEqualToString:ACAccountTypeIdentifierSinaWeibo]){
        
        return SLServiceTypeSinaWeibo;
        
    }else if ([accountIdentifier isEqualToString:ACAccountTypeIdentifierTwitter]){
        
        return SLServiceTypeTwitter;
        
    }else if ([accountIdentifier isEqualToString:ACAccountTypeIdentifierTencentWeibo]){
        
        return SLServiceTypeTencentWeibo;
        
    }
    
    return nil;
    
}

#pragma mark - Assertions

-(void)assertRequest:(id)request{
    
    NSAssert(request, @"%@", [NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2003]);
    NSAssert( [request isKindOfClass:[SLRequest class]],@"%@", [NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2004]);
    
}


@end
