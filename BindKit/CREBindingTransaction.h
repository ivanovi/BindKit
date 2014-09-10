//
//  CREBindingDefinition.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CREBindingUnit.h"

typedef NS_ENUM(NSUInteger, CREBindingTransactionDirection) {
    
    CREBindingTransactionDirectionBothWays,
    CREBindingTransactionDirectionOneWay,
    CREBindingTransactionDirectionChained,
    
};

@interface CREBindingTransaction : NSObject{
    
    __weak CREBindingUnit * sourceUnit;
    
}

@property (nonatomic, readonly) NSSet * boundObjects;
@property (nonatomic, readonly) NSSet * keys;
@property (nonatomic, readonly) NSArray * bindingUnits; //immediate/current units
@property (nonatomic, readonly) CREBindingTransactionDirection directionType;

//- (instancetype)initWithDictionary:(NSDictionary*)bindingDict;
- (instancetype)initWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;


- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict; //key => represents the property ; value => the instance
- (void)addBindingUnit:(CREBindingUnit*)subBindingUnit;
- (void)setSourceBindingUnit:(CREBindingUnit*)sourceUnit;

- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit;

- (NSSet*)bindingUnitsForProperties:(NSString*)property;
- (NSSet*)bindingUnitsForObject:(id)boundObject;

-(void)mergeValue:(id)value toTarget:(CREBindingUnit*)target;
-(BOOL)containsUnit:(CREBindingUnit*)unit;

@end
