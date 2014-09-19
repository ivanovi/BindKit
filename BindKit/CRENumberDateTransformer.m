//
//  CRENumberDateTransformer.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/19/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CRENumberDateTransformer.h"

@implementation CRENumberDateTransformer


-(id)bindRelation:(CREBindRelation *)relation willModify:(CREBindingUnit *)unit withValue:(id)value{
    
    NSAssert([value isKindOfClass:[NSNumber class]], [NSError errorDescriptionForDomain:kCREBinderErrorTransformer code:3003] );
        
    return  [NSDate dateWithTimeIntervalSince1970: (NSTimeInterval)[(NSNumber*)value integerValue] ];;
    
}

@end
