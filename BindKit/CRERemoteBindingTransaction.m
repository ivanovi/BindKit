//
//  CRERemoteBindingTransaction.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRERemoteBindingTransaction.h"

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
        
        NSURLRequest *request = [self remoteItemRequest:sourceUnit.value];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                
                NSLog(@"received response with value set %@", value);
                
                
            }else{
                //handle error
                
                  NSLog(@"received response with value set %@", [connectionError localizedDescription]);
                
            }
            
            
            if (_callBack) {
                
                _callBack(value, target, connectionError);
                
            }
            
            
        }];
        
        
        
    }
    
}



-(NSURLRequest*)remoteItemRequest:(id)requestAddress{
    
    
    if ([requestAddress isKindOfClass: [NSString class] ]) {
        
        return [NSURLRequest requestWithURL: [NSURL URLWithString:requestAddress] ];
        
    }else{
        
        return [NSURLRequest requestWithURL: requestAddress];
        
    }
    
    
}

-(void)assertSource{
    
    if (sourceUnit.value)
    {
        
        NSAssert( ([sourceUnit.value isKindOfClass: [NSString class] ] || [sourceUnit.value isKindOfClass: [NSString class] ] ), @"%s Error: %@", __PRETTY_FUNCTION__ , [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:105] );
        
    }
    
}

#pragma mark - NSURLConnection Delegate



#pragma mark - NSURLConnectionDataDelegate


//-(CREBindingTransactionDirection)directionType{
//    
//    return CREBindingTransactionDirectionOneWay;
//    
//}


@end
