//
//  CREBindingDefinition.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CREBindingDefinition : NSObject

@property (nonatomic, readonly) NSSet * boundObjects;
@property (nonatomic, readonly) NSSet * keys;

- (instancetype)initWithDictionary:(NSDictionary*)bindingDict;

- (void)addPropertyTargetRelation:(NSDictionary*)propertyTargetDict;
- (void)removePropertyTargetRelation: (NSString*) propertyString;

- (NSDictionary*)propertyTargetRelationForProperty:(NSString*)property;


@end
