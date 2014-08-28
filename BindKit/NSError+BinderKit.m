//
//  NSError+BinderKit.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "NSError+BinderKit.h"

NSString * const kCREBinderErrorSetupDomain = @"binderErrorSetupErrorDomain";
NSString * const kCREBinderWarningsDomain = @"binderErrorWarnigsDomain";

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
        
        return [NSError errorDescriptionForSetupDomain:errorCode - 1000];

    }
    
    return [NSError errorDescriptionForDefaultDomain:errorCode];
}

#pragma mark - Private Methods

#pragma mark - | Error Description Literals Mapping

+(NSString*)errorDescriptionForSetupDomain:(NSInteger)errorCode{
    
   
    NSArray *errorDescritionsLiteralsArray =
    @[@"Adding pair using dictionaries is allowed only for one-to-one relationships (maximum two objects at a time).",
      @"CREBinderDefinition must be initialised with mapping dictionary."];
    
    
    return errorDescritionsLiteralsArray [ errorCode ];

    
}


+(NSString*)errorDescriptionForDefaultDomain:(NSInteger)errorCode{
    
    NSArray *errorDescritionsLiteralsArray =
    @[@"Mandatory delegate method not implemented."];
    
    return errorDescritionsLiteralsArray [ errorCode ];
    
}


+(NSString*)errorDescriptionWarnings:(NSInteger)errorCode{
    
    NSArray *errorDescritionsLiteralsArray =
    @[];
    
    return errorDescritionsLiteralsArray [ errorCode ];
    
}
@end
