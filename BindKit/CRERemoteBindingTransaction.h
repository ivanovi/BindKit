//
//  CRERemoteBindingTransaction.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <BindKit/BindKit.h>

/**
 This class binds key-value pairs (CREBindingUnit) to an url. The url is assumed to by in a property and is passed again as a key-value pair (CREBindingUnit).
 The type of the url can be either NSString or NSURL. 
 
 It supports custom requests of type NSURLRequest and SLRequest. You create and setup this request and set the property request before calling the "bind" method.
 
 */


typedef void (^CRERemoteBinderCallBack)(id newValue, CREBindingUnit *unit, NSError *error);


@interface CRERemoteBindingTransaction : CREBindingTransaction  <NSURLConnectionDataDelegate>

/**
 Pass pre-configured SLRequest => a request to Facebook / Twitter / Waebo
 or standard NSURLRequest. If the request property is not set, 
 */

@property (nonatomic, strong) id request;
@property (nonatomic, readwrite, copy) CRERemoteBinderCallBack callBack;



@end
