//
//  NSError+BinderKit.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "NSError+BinderKit.h"

NSString * const kCREBinderErrorDomainSetup = @"setupErrorDomain";

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
    
    if ([errorDomain isEqualToString:kCREBinderErrorDomainSetup]) {
        
        return [NSError errorDescriptionForSetupDomain:errorCode - 100];
    }
    
    return [NSError errorDescriptionForDefaultDomain:errorCode];
}

#pragma mark - Private Methods

+(NSString*)errorDescriptionForSetupDomain:(NSInteger)errorCode{
    
   
    NSArray *errorDescritionsLiteralsArray =
    @[@"Adding pair using dictionaries is allowed only for one-to-one relationships (maximum two objects at a time)."];
    
    
    return errorDescritionsLiteralsArray [ errorCode ];

    
}


+(NSString*)errorDescriptionForDefaultDomain:(NSInteger)errorCode{
    
    NSArray *errorDescritionsLiteralsArray =
    @[];
    
    return errorDescritionsLiteralsArray [ errorCode ];
    
}
@end
