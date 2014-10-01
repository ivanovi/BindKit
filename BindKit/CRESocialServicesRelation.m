//
//  CRESocialServicesRelation.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/17/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.




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
