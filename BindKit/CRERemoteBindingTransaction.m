//
//  CRERemoteBindingTransaction.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Ivan Ivanov, Creatub Ltd.

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



#import "CRERemoteBindingTransaction.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface CRERemoteBindingTransaction(){
    
    NSURL *urlContainer;
    id remoteRequest;
    
}

@end

@implementation CRERemoteBindingTransaction



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
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: completionHandler];
        
    
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
    
    if (!request) {
        
        NSLog(@"assertion will fail");
        
    }
    
    NSAssert(request, @"__FIX request factory must return a valid request");
    NSAssert( ( [request isKindOfClass:[NSURLRequest class]] ||
               [request isKindOfClass:[SLRequest class]] ), @"__FIX Supporting only SLRequest and NSURLRequest");
    
}


-(void)assertSource{
    
    if (sourceUnit.value)
    {
        
        NSAssert( ([sourceUnit.value isKindOfClass: [NSString class] ] || [sourceUnit.value isKindOfClass: [NSString class] ] ), @"%s Error: %@ Source unit %@", __PRETTY_FUNCTION__ , [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:105], sourceUnit.value );
        
    }
    
}


#pragma mark - Custom requests


-(NSURLRequest*)createRequest:(id)requestAddress{
    
    
    [self resolveRequestAdderss:requestAddress];
    
    
    if ([_requestFactory respondsToSelector:@selector(bindTransaction:forURL:unit:parameters:)])
    {
        
      id receivedRequest = [_requestFactory bindTransaction:self forURL:urlContainer unit:sourceUnit parameters:nil];
      [self assertRequest:receivedRequest];
       
      return receivedRequest;
        
    }
    
    if (remoteRequest) {
        
        //copying the request with the new request address
        return [self requestWithRequest:remoteRequest];
        
    }else{
        
        return [NSURLRequest requestWithURL:urlContainer];
        
    }
    
}


-(id)requestWithRequest:(id)request{
    //
    
    if (_requestFactory) {
        
        return remoteRequest;
        
    }
    
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

-(id)handleResponse:(NSData*)responseData urlResponse:(NSURLResponse*)response targetUnit:(CREBindingUnit*)targetUnit{
    
    NSString *mimeType = response.MIMEType;
    id newValue = nil;
    NSDictionary *receivedDictionary = nil;
    
    if ([mimeType rangeOfString:@"image"].location != NSNotFound)
    {
        
        newValue = responseData;
        
    }else{
        
        
        receivedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        NSString *remoteKey = targetUnit.remoteProperty ? targetUnit.remoteProperty : targetUnit.boundObjectProperty;
        
        newValue = [receivedDictionary valueForKey:remoteKey];
        
        
    }
    
    NSAssert(newValue, @"__FIX New value not set receivedDict %@ mimeType %@", receivedDictionary, mimeType);
    
    return newValue;
}


//-(CREBindingTransactionDirection)directionType{
//    
//    return CREBindingTransactionDirectionOneWay;
//    
//}


@end
