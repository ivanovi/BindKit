//
//  CREImageDataTransformer.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/18/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREImagePNGDataTransformer.h"

@implementation CREImagePNGDataTransformer


-(id)bindRelation:(CREBindRelation *)Relation willModify:(CREBindingUnit *)unit withValue:(id)value{
    
    NSAssert([value isKindOfClass: [UIImage class] ], [NSError errorDescriptionForDomain:kCREBinderErrorTransformer code:3001] );
#ifdef DEBUG //unit is not mandatory
    if (unit)
    {
        NSAssert([unit.value isKindOfClass: [NSData class] ], [NSError errorDescriptionForDomain:kCREBinderErrorTransformer code:3000] );
    }
    
#endif
    return UIImagePNGRepresentation(value);
    
}

@end
