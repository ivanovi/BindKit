//
//  CRERemoteBindingTransaction.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREBindingTransaction.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

/**
 This class binds key-value pairs (CREBindingUnit) to an url. The url is assumed to by in a property and is passed again as a key-value pair (CREBindingUnit).
 The type of the url can be either NSString or NSURL. 
 
 It supports custom requests of type NSURLRequest and SLRequest. You create and setup this request and set the property request before calling the "bind" method.
 
 */


typedef NS_ENUM(NSUInteger, CREBinderRequestType) {
    CREBinderRequestTypeURL,
    CREBinderRequestTypeFacebook,
    CREBinderRequestTypeTwitter,
    CREBinderRequestTypeWeibo,
    CREBinderRequestTypeTencentWeibo,
};

@class CRERemoteBindingTransaction;

@protocol CREBinderRequestFactory <NSObject>

-(id)bindTransaction:(CRERemoteBindingTransaction*)bindingTransaction forURL:(NSURL*)url unit:(CREBindingUnit*)unit parameters:(NSDictionary*)params;

@end

typedef void (^CRERemoteBinderCallBack)(id newValue, CREBindingUnit *unit, NSError *error);


@interface CRERemoteBindingTransaction : CREBindingTransaction 

/**
 Pass pre-configured SLRequest => a request to Facebook / Twitter / Waebo
 or standard NSURLRequest. If the request property is not set, 
 */
@property (nonatomic, weak) id <CREBinderRequestFactory> requestFactory;
@property (nonatomic, readonly) CREBinderRequestType requestType;
@property (nonatomic, readwrite, copy) CRERemoteBinderCallBack callBack;



@end
