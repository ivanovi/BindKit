//
//  NSError+BinderKit.m
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



#import "NSError+BinderKit.h"

NSString * const kCREBinderErrorSetupDomain = @"binderErrorSetupErrorDomain";
NSString * const kCREBinderWarningsDomain = @"binderErrorWarnigsDomain";
NSString * const kCREBinderErrorLogic = @"binderErrorLogicDomain";
NSString * const kCREBinderErrorTransformer = @"binderErrorTransformerDomain";

static NSDictionary * errorMessagesDictionary;

@implementation NSError (BinderKit)


+(NSError*)errorWithBinderDomain:(NSString *)domainString code:(NSInteger)errorCode{
    
    
    NSString * errorDescription = [ NSError errorDescriptionForDomain:domainString code:errorCode ];
    
    
    
    return [NSError errorWithDomain:domainString
                               code:errorCode
                           userInfo:@{@"localizedDescription":errorDescription }];
    
    
}

+(void)unarchiveErrorMessages{
    
    
    if (!errorMessagesDictionary)
    {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"CREBinder")];
        NSString *path = [bundle pathForResource:@"BindKitErrorMessages" ofType:@"plist"];
        
        errorMessagesDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        
    }
    
}

+(NSString*)errorDescriptionForDomain:(NSString*)errorDomain code:(NSInteger)errorCode{
    
    [self unarchiveErrorMessages];
    
    NSArray *errorMessagesForDomain = errorMessagesDictionary [ errorDomain ];
    NSInteger normalizedCode = [NSError normalizeCodeForDomain:errorDomain code:errorCode];
    
    return errorMessagesForDomain [normalizedCode];
    
}

#pragma mark - Private Methods

+(NSInteger)normalizeCodeForDomain:(NSString*)errorDomain code:(NSInteger)errorCode{
    
        if ([errorDomain isEqualToString:kCREBinderErrorSetupDomain]) {
    
            return errorCode - 100;
    
        } else if ([errorDomain isEqualToString:kCREBinderWarningsDomain]){
    
            return errorCode - 1000;
    
        } else if ([errorDomain isEqualToString:kCREBinderErrorTransformer]){
    
            return errorCode - 3000;
    
        }
        else if ([errorDomain isEqualToString:kCREBinderErrorLogic]){
    
            return errorCode - 2000;
    
        }
    
        return errorCode;

}


@end
