//
//  CREBindingDefinition.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CREBindingUnit.h"

@interface CREBindingTransaction : NSObject

@property (nonatomic, readonly) NSSet * boundObjects;
@property (nonatomic, readonly) NSSet * keys;
@property (nonatomic, readonly) NSSet * bindingUnits;

- (instancetype)initWithDictionary:(NSDictionary*)bindingDict;

- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict; //key => represents the property ; value => the instance
- (void)addBindingUnit:(CREBindingUnit*)subBindingUnit;
- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit;

- (NSSet*)bindingUnitsForProperties:(NSString*)property;
- (NSSet*)bindingUnitsForObject:(id)boundObject;


@end
