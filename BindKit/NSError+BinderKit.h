//
//  NSError+BinderKit.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides only BinderKit specific error descriptions based on domain and errorCode
 */

extern NSString * const kCREBinderErrorSetupDomain;
extern NSString * const kCREBinderWarningsDomain;
extern NSString * const kCREBinderErrorInternalDomain;

@interface NSError (BinderKit)

+(NSError*)errorWithBinderDomain:(NSString*)domainString code:(NSInteger)errorCode;
+(NSString*)errorDescriptionForDomain:(NSString*)domainString code:(NSInteger)errorCode;

@end
