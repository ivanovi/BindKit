//
//  NSError+BinderKit.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
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


#import <Foundation/Foundation.h>

/**
 
 Provides the framework specific error descriptions based on domain and errorCode. Adding more messages or domains requires modifiyng the file BindKitErrorMessage.plist and/or the global string variables here.
 
 */

extern NSString * const kCREBinderErrorSetupDomain;
extern NSString * const kCREBinderWarningsDomain;
extern NSString * const kCREBinderErrorLogic;
extern NSString * const kCREBinderErrorTransformer;

@interface NSError (BinderKit)

+(NSError*)errorWithBinderDomain:(NSString*)domainString code:(NSInteger)errorCode;
+(NSString*)errorDescriptionForDomain:(NSString*)domainString code:(NSInteger)errorCode;

@end
