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
NSString * const kCREBinderErrorInternalDomain = @"binderErrorInternal";
NSString * const kCREBinderErrorLogic = @"binderErrorLogicDomain";
NSString * const kCREBinderErrorTransformer = @"binderErrorTransformer";


@implementation NSError (BinderKit)


+(NSError*)errorWithBinderDomain:(NSString *)domainString code:(NSInteger)errorCode{
    
    NSString * errorDescription = [ NSError errorDescriptionForDomain:domainString code:errorCode ];
    NSString * scopedDomain = [NSString stringWithFormat:@"%@%@%@",
                               [[NSBundle mainBundle] bundleIdentifier],
                               [[NSBundle mainBundle] infoDictionary] [@"CFBundleVersion"] ,
                               domainString];
    
    return [NSError errorWithDomain:scopedDomain
                               code:errorCode
                           userInfo:@{@"localizedDescription":errorDescription }];
    
    
}



+(NSString*)errorDescriptionForDomain:(NSString*)errorDomain code:(NSInteger)errorCode{
    
    if ([errorDomain isEqualToString:kCREBinderErrorSetupDomain]) {
        
        return [NSError errorDescriptionForSetupDomain:errorCode - 100];
    
    } else if ([errorDomain isEqualToString:kCREBinderWarningsDomain]){
        
        return [NSError errorDescriptionWarnings:errorCode - 1000];

    } else if ([errorDomain isEqualToString:kCREBinderErrorLogic]){
        
        return [NSError errorDescriptionLogic:errorCode - 2000];

    } else if ([errorDomain isEqualToString:kCREBinderErrorTransformer]){
        
        return [NSError errorDescriptionTransformer:errorCode - 3000];
        
    }
    
    
    return [NSError errorDescriptionForDefaultDomain:errorCode];
}

#pragma mark - Private Methods

#pragma mark - | Error Description Literals Mapping

+(NSString*)errorDescriptionForSetupDomain:(NSInteger)errorCode{
    
   
    NSArray *errorDescritionsLiteralsArray =
    @[@"Adding pair using dictionaries is allowed only for one-to-one relationships (maximum two objects at a time).",
      @"CREBinderDefinition must be initialised with mapping dictionary.",
      @"INTERNAL - BindingUnit: Instance can be initialized with only one property : instance pair.",
      @"INTERNAL - BindingUnit: Bounding Object does contain added property.",
      @"Each property-name in the 'property' array must correspond to a matching sourceObject.",
      @"RemoteBinder's source property can be either NSString or NSUrl instance.",
      @"ValueTransformer did not implement mandatory method.",
      @"ValueTransformer class not found."];
    
    
    return errorDescritionsLiteralsArray [ errorCode ];

    
}


+(NSString*)errorDescriptionForDefaultDomain:(NSInteger)errorCode{
    
    NSArray *errorDescritionsLiteralsArray =
    @[@"Mandatory delegate method not implemented."];
    
    return errorDescritionsLiteralsArray [ errorCode ];
    
}


+(NSString*)errorDescriptionWarnings:(NSInteger)errorCode{
    
    NSArray *errorDescritionsLiteralsArray =
    @[@"Called setValue:ForKeyPath: with value of nil."];
    
    return errorDescritionsLiteralsArray [ errorCode ];
    
}

+(NSString*)errorDescriptionLogic:(NSInteger)errorCode{
    
    NSArray *errorDescritionsLiteralsArray =
    @[@"Received request to merge unit that was not added to any Relation",
      @"A binding unit can be assigned to only one Relation.",
      ];
    
    return errorDescritionsLiteralsArray [ errorCode ];
}


+(NSString*)errorDescriptionTransformer:(NSInteger)errorCode{
    
    NSArray *errorDescritionsLiteralsArray =
    @[@"DataToImage transformer received object of incompatible type (expected NSData).",
      @"NegateTransformer expects NSNumber instance passed as the 'value' parameter.",
      @"NegateTransformer expects NSNumber instance passed as the 'value' parameter."];
    
    return errorDescritionsLiteralsArray [ errorCode ];
}
@end
