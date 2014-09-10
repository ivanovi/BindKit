//
//  CRERemoteBindingTransaction.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <BindKit/BindKit.h>


typedef void (^CRERemoteBinderCallBack)(id newValue, CREBindingUnit *unit, NSError *error);


@interface CRERemoteBindingTransaction : CREBindingTransaction  <NSURLConnectionDataDelegate>



@property (nonatomic, readwrite, copy) CRERemoteBinderCallBack callBack;



@end
