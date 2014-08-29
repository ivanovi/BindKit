//
//  CREBindingUnit.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/29/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+BinderKit.h"

/**
 The smallest unit of abstraction, encapsulating a object, its property and context.
 
 */

@interface CREBindingUnit : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)bindingMappingDictionary;

@property (nonatomic, weak) id boundObject;
@property (nonatomic, weak) id boundObjectProperty;
//@property (nonatomic, strong) NSDictionary *bindOptionsDictionary; // redo with enumeration

-(BOOL)compareWithDict:(NSDictionary*)dictionary;

@end
