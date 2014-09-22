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
#import "CREMapperProtocol.h"

@class CRERemoteBindingRelation;

typedef void (^CRERemoteBinderCallBack)(id newValue, CREBindingUnit *unit, NSError *error);


@interface CRERemoteBindingRelation : CREBindRelation <CREBindRelationRequestDelegate>{
     id remoteRequest;
     NSURL *urlContainer;
}

@property (nonatomic, readwrite, copy) CRERemoteBinderCallBack callBack;
@property (nonatomic, weak) id <CREMapperProtocol> remoteKeyMapper;

-(id)requestWithRequest:(id)request;
-(void)executeRequest:(id)request withCallBack:(void (^)(NSURLResponse *response,
                                                         NSData *data,
                                                         NSError *connectionError)) completionHandler;

-(void)assertSource;
-(void)assertRequest:(id)request;

-(void)setValue:(id)value forUnit:(CREBindingUnit*)bindingUnit;

@end
