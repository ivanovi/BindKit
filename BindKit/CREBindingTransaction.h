//
//  CREBindingDefinition.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CREBindingUnit.h"


@class CREBindingTransaction;


/**
 === Delegation ===
 We provide delegation to serve as an entry point for the viewControllers' modification of binding behavior at run-time. The controllers normally hold most of the context information.
 */
@protocol CREBindTransactionDelegate <NSObject>

/**
 The below method is called after a value has been changed in one of the objects in a pair. If TRUE is returned the mergeValue:toTarget:withKeyPath: is called (which you can override to provide custom merge behavior, e.g. animation, transitions etc. ).
 */
-(BOOL)bindTransaction:(CREBindingTransaction*)transaction shouldSetValue:(id)value forKeyPath:(NSString*)keyPath;

@optional

/**
 The below method is called after binder:shouldSetValue:forKeyPath: has returned TRUE and before mergeValue:toTarget:withKeyPath:
 Here you can do value transformations to map types, proper formatting etc., if needed.
 */
-(void)bindTransaction:(CREBindingTransaction*)transaction willSetValue:(id)value forKeyPath:(NSString*)keyPath inObject:(id)targetObject;

@end


@protocol CREValueTransformerProtocol <NSObject>

//Value transformer object must resturn transformed value //not nil
-(id)bindTransaction:(CREBindingTransaction*)transaction willModify:(CREBindingUnit*)unit withValue:(id)value;

@end

@protocol CREPlaceholderProtocol <NSObject>

//Placeholder object must return placeholder value //not nil
-(id)bindTransaction:(CREBindingTransaction*)transaction requiresPlaceholderValuesForUnit:(CREBindingUnit*)unit;

@end

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
@property (nonatomic, weak) id <CREValueTransformerProtocol> valueTransformer;
@property (nonatomic, weak) id <CREPlaceholderProtocol> placeholder;
@property (nonatomic, weak) id <CREBindTransactionDelegate> delegate;
@property (nonatomic, readonly) BOOL isLocked;

//- (instancetype)initWithDictionary:(NSDictionary*)bindingDict;
- (instancetype)initWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;


- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict; //key => represents the property ; value => the instance
- (void)addBindingUnit:(CREBindingUnit*)subBindingUnit;
- (void)setSourceBindingUnit:(CREBindingUnit*)sourceUnit;
- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit;

- (NSSet*)bindingUnitsForProperties:(NSString*)property;
- (NSSet*)bindingUnitsForObject:(id)boundObject;


-(void)handleInitialValue:(id)value unit:(CREBindingUnit*)unit;
-(void)mergeValue:(id)value toTarget:(CREBindingUnit*)target;
-(BOOL)containsUnit:(CREBindingUnit*)unit;

@end
