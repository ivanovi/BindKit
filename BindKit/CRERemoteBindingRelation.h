//
//  CRERemoteBindingRelation.h
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




#import "CREBindRelation.h"


@class CRERemoteBindingRelation;




typedef void (^CRERemoteBinderCallBack)(id newValue, CREBindingUnit *unit, NSError *error);


@interface CRERemoteBindingRelation : CREBindRelation <CREBindRelationRequestDelegate>

//@property (nonatomic, weak) id <CREBinderRequestFactory> requestFactory;
@property (nonatomic, readwrite, copy) CRERemoteBinderCallBack callBack;


-(void)assertSource;
-(void)assertRequest:(id)request;

-(id)requestWithRequest:(id)request;
-(NSURLRequest*)createRequest:(id)requestAddress;

-(id)handleResponse:(NSData*)responseData urlResponse:(NSURLResponse*)response targetUnit:(CREBindingUnit*)targetUnit;


@end