//
//  CREIsNilTransformer.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/18/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import "CREIsNilTransformer.h"

@implementation CREIsNilTransformer

-(id)bindRelation:(CREBindRelation *)Relation willModify:(CREBindingUnit *)unit withValue:(id)value{
    
    if (value) {
        
        return [NSNumber numberWithBool:NO];
        
    }else{
   
        return [NSNumber numberWithBool:YES];
    
    }
    
   
}

@end
