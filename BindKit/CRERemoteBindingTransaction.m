//
//  CRERemoteBindingTransaction.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRERemoteBindingTransaction.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface CRERemoteBindingTransaction(){
    
    NSURL *urlContainer;
    
}

@end

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

#pragma mark - Overrides

-(instancetype)initWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray{
    self = [super initWithProperties:propertiesArray sourceObjects:objectsArray];
    
    if (self)
    {
        
        [self setSourceBindingUnit:self.bindingUnits[0] ];
        
        [self assertSource];
        
    }
    
    return self;
}

-(void)mergeValue:(id)value toTarget:(CREBindingUnit *)target{
    
    [self assertSource];
    
    if (![target isEqual:sourceUnit])
    {
        
        NSURLRequest *request = [self createRequest:sourceUnit.value];
        
        [self executeRequest:request withCallBack:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            id newValue = nil;
            
            if (!connectionError) {
                
                NSDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *remoteKey = sourceUnit.remoteProperty ? sourceUnit.remoteProperty : sourceUnit.boundObjectProperty;
                
                newValue = [receivedDictionary valueForKey:remoteKey];
                
                NSAssert(newValue, @"no newValue");
                
                [target.boundObject setValue:newValue forKey:target.boundObjectProperty];
                
                NSLog(@"received response with value set %@", receivedDictionary);
                
            }else{
                //handle error
                
                NSLog(@"received response with value set %@", [connectionError localizedDescription]);
                
            }
            
            if (_callBack) {
                
                _callBack(newValue, target, connectionError);
                
            }
            
            
        }];
        
        
        
    }
    
}

-(void)executeRequest:(id)request withCallBack:(void (^)(NSURLResponse *response,
                                                         NSData *data,
                                                         NSError *connectionError)) completionHandler{
    
    [self assertRequest:request];
    
    if ([request isKindOfClass:[NSURLRequest class]] ) {
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: completionHandler];
        
    }else if ( [request isKindOfClass:[SLRequest class]] ){
        
        [(SLRequest*)request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            completionHandler (urlResponse,responseData,error);
            
        }];
        
    }
    
    
    
}


-(void)resolveRequestAdderss:(id)requestAddress{
    
    if ([requestAddress isKindOfClass: [NSString class] ]) {
        
        urlContainer = [NSURL URLWithString:requestAddress] ;
        
    }else{
        
        urlContainer = requestAddress;
        
    }
    
    
}

#pragma mark - Assertions

-(void)assertRequest:(id)request{
    
    NSAssert( ( [request isKindOfClass:[NSURLRequest class]] || [request isKindOfClass:[SLRequest class]] ), @"__FIX Supporting only SLRequest and NSURLRequest");
    
}


-(void)assertSource{
    
    if (sourceUnit.value)
    {
        
        NSAssert( ([sourceUnit.value isKindOfClass: [NSString class] ] || [sourceUnit.value isKindOfClass: [NSString class] ] ), @"%s Error: %@", __PRETTY_FUNCTION__ , [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:105] );
        
    }
    
}


#pragma mark - Custom requests


-(NSURLRequest*)createRequest:(id)requestAddress{
    
    
    [self resolveRequestAdderss:requestAddress];
    
    if (_request) {
        
        //copying the request with the new request address
        return [self requestWithRequest:_request];
        
    }else{
        
        return [NSURLRequest requestWithURL:urlContainer];
        
    }
    
}


-(id)requestWithRequest:(id)request{
    //
    [self assertRequest:request];
    
    if ([request isKindOfClass:[SLRequest class]]) {
        
        SLRequest *initialRequest = request;
        
        return [SLRequest requestForServiceType:[self resolveAcountServiceToSLserviceWithAccount:initialRequest.account.accountType.identifier]
                                  requestMethod:initialRequest.requestMethod
                                            URL:urlContainer
                                     parameters:initialRequest.parameters];
        
    }else if ([request isKindOfClass:[NSURLRequest class]]){
        
        NSURLRequest *initialRequest = request;
        
        return [NSURLRequest requestWithURL:urlContainer cachePolicy:initialRequest.cachePolicy timeoutInterval:initialRequest.timeoutInterval];
    }
    
    return nil;
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


//-(CREBindingTransactionDirection)directionType{
//    
//    return CREBindingTransactionDirectionOneWay;
//    
//}


@end
