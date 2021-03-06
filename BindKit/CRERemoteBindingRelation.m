//
//  CRERemoteBindingRelation.m
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



#import "CRERemoteBindingRelation.h"
#import "CREBindingUnit.h"


@interface CRERemoteBindingRelation()

@end


@implementation CRERemoteBindingRelation

@synthesize requestFactory = _requestFactory;

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
                
                newValue = [self handleResponse:data urlResponse:response targetUnit:target];
                NSAssert(newValue, @"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2000]);
                
                [self setValue:newValue forUnit:target];
                
            }else{
                //handle error
                
                NSLog(@"received ERROR response with value set %@ url %@", [connectionError localizedDescription], sourceUnit.value);
                
            }
            
            if (_callBack)
            {
                
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

    NSAssert(request, @"%@", [NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2001]);
    NSAssert( [request isKindOfClass:[NSURLRequest class]], @"%@", [NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2002]);
    
}


-(void)assertSource{
    
    if (sourceUnit.value)
    {
        
        NSAssert( ([sourceUnit.value isKindOfClass: [NSString class] ] || [sourceUnit.value isKindOfClass: [NSURL class] ] ), @"%s Error: %@ Source unit %@", __PRETTY_FUNCTION__ , [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:105], sourceUnit.value );
        
    }
    
}


#pragma mark - Custom requests


-(NSURLRequest*)createRequest:(id)requestAddress{
    
    
    [self resolveRequestAdderss:requestAddress];
    
    
    if ([_requestFactory respondsToSelector:@selector(bindRelation:forURL:unit:parameters:)])
    {
        
      id receivedRequest = [_requestFactory bindRelation:self forURL:urlContainer unit:sourceUnit parameters:nil];
      [self assertRequest:receivedRequest];
       
        
      return receivedRequest;
        
    }
    
    if (_remoteRequest)
    {
        
        return [self requestWithRequest:_remoteRequest];
        
    }else{
        
        return [NSURLRequest requestWithURL:urlContainer];
        
    }
    
}


-(id)requestWithRequest:(id)request{
    

    
    [self assertRequest:request];

    NSURLRequest *initialRequest = request;
    
    return [NSURLRequest requestWithURL:urlContainer cachePolicy:initialRequest.cachePolicy timeoutInterval:initialRequest.timeoutInterval];
    
}




-(id)handleResponse:(NSData*)responseData urlResponse:(NSURLResponse*)response targetUnit:(CREBindingUnit*)targetUnit{
    
    NSString *mimeType = response.MIMEType;
    id newValue = nil;
    NSDictionary *receivedObject = nil;
    
    if ([mimeType rangeOfString:@"image"].location != NSNotFound)
    {
        
        newValue = responseData;
        
    }else{
    
        @try
        {
            
            receivedObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];

        }
        @catch (NSException *exception)
        {
            
            NSLog(@"Possibly unsupported API. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:106]);
            
        }
        
        //this will extract only one key-value pair matching and not the whole JSON object
        newValue = [self parseReceivedObject:receivedObject target:targetUnit];
        
        
    }
    
    NSAssert(newValue, @"%@. New value not set receivedDict %@ mimeType %@",[NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2000], receivedObject, mimeType);
    
    return newValue;
}

-(void)setValue:(id)value forUnit:(CREBindingUnit *)bindingUnit{
    
    if ([self.valueTransformer respondsToSelector:@selector(bindRelation:willModify:withValue:)])
    {
        
        value = [self.valueTransformer bindRelation:self willModify:bindingUnit withValue:value];
        
    }
    

        [bindingUnit setValue:value];

}

-(id)parseReceivedObject:(id)object target:(CREBindingUnit*)unit{
    
    //making sure we've got a dictionary, the only supported resoponse for now
    
#ifndef DEBUG
    NSAssert(![object isKindOfClass: [NSArray class] ], [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:107]);
#else
    //the placeholder JSON Api provides only lists
    if ([object isKindOfClass:[NSArray class]])
    {
        
        object = object [0];
        
    }
    
#endif
    
    SEL remoteMappingSelector = @selector(remoteKeyForLocalKey:inLocalClass:);
    id targetObject = unit.boundObject;
    id targetProperty = unit.boundObjectProperty;
    NSString * targetClassName = NSStringFromClass([targetObject class]);
    
    NSString *remoteKey = nil;

    if ([_remoteKeyMapper respondsToSelector:remoteMappingSelector]) {
        
        remoteKey = [_remoteKeyMapper remoteKeyForLocalKey:targetProperty inLocalClass: targetClassName ];
        
        NSAssert(remoteKey,
                 @"RemoteKeyMapper cannot return nil %@. %@", unit, [NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2005]);

        
    }else if ([targetObject respondsToSelector:remoteMappingSelector]){
        
        remoteKey = [targetObject remoteKeyForLocalKey:targetProperty inLocalClass:targetClassName];
        
    }
    
    NSAssert(remoteKey,
             @"Could not resolve remote key for object %@. %@", unit, [NSError errorDescriptionForDomain:kCREBinderErrorLogic code:2005]);

    
    return [object valueForKey:remoteKey];
    
}


-(void)bind{
    
    
    if ( ! (_remoteRequest || _requestFactory) ) {
          NSLog(@"%@", [NSError errorDescriptionForDomain:kCREBinderWarningsDomain code:1002]);
    }
  
    [super bind];
    
}




@end
