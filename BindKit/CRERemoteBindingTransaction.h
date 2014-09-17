//
//  CRERemoteBindingTransaction.h
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
