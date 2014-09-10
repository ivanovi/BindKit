//
//  CREBinder.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CREBindingTransaction.h"
#import "NSError+BinderKit.h"

/**
 === General Information ===
 The binder class provides a one-to-one binding behavior for two objects (or more via additional one-to-one pairs) in both directions. It is set as observer for the values of both objects and serves as an additional layer. The instances can own other binders to account for more complex relations or multiple bindings in a given context.
 
 */

@class CREBinder;

#pragma mark - Binder delegate

/**
 === Delegation ===
   We provide delegation to serve as an entry point for the viewControllers' modification of binding behavior at run-time. The controllers normally hold most of the context information.
 */
@protocol CREBinderDelegate <NSObject>

/**
 The below method is called after a value has been changed in one of the objects in a pair. If TRUE is returned the mergeValue:toTarget:withKeyPath: is called (which you can override to provide custom merge behavior, e.g. animation, transitions etc. ).
 */
-(BOOL)binder:(CREBinder*)binder shouldSetValue:(id)value forKeyPath:(NSString*)keyPath;

@optional

/**
 The below method is called after binder:shouldSetValue:forKeyPath: has returned TRUE and before mergeValue:toTarget:withKeyPath:
 Here you can do value transformations to map types, proper formatting etc., if needed.
 */
-(void)binder:(CREBinder*)binder willSetValue:(id)value forKeyPath:(NSString*)keyPath inObject:(id)targetObject;

@end

@interface CREBinder : NSObject

@property (nonatomic, weak) id <CREBinderDelegate> delegate;
@property (nonatomic, weak, readonly) CREBinder * superBinder;
@property (nonatomic, readonly) NSArray * childBinders;
@property (nonatomic, readonly) NSArray * transactions; //returns Array of Binding definition
@property (nonatomic, readonly) BOOL isLocked;

//@property (nonatomic, readonly, strong) NSDictionary *mappingDictonary; //the dictionary that sets the mapping structure. Set the property name

#pragma mark - Initialization
/**
 == Interface ==
 
 See addPair: explanation method for example structure relevant to mapDictionary.
 */
//+(instancetype)binderWithMapping:(NSDictionary*)mapDictionary;
//-(instancetype)initWithMapping:(NSDictionary*)mapDictionary;

+(instancetype)binderWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;
-(instancetype)initWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;


#pragma mark - Setup



-(void)addTransaction:(CREBindingTransaction*)bindingTransaction;

/**
 A convinience method that brings the same result as the above method (addBindingDefinition:). Use as the following example, where dictionaries stand for dummy model or other objects:
 
     NSMutableDictionary *aDictionary = [NSMutableDictionary dictionaryWithObject:@"aDictionary" forKey:@"id"];
     NSMutableDictionary *bDictionary = [NSMutableDictionary dictionaryWithObject:@"bDictionary" forKey:@"id"];
    
     [aBinder addPair: @{@"propertyA":aDictionary, //property and object are coupled in key value pair => the key is the property of the object
                         @"propertyB":bDictionary}]];
 
    The structure is automatically converted to CREBindingDefinition instance and added to the pairs stack. If you want remove it later from the stack you should keep its reference.
 */
//-(CREBindingTransaction*)addPair:(NSDictionary*)objectsPair;
-(void)removeTransaction:(CREBindingTransaction*)removingTransaction;

/**
 Adding and removing binders to the binder stack. In the general case they are exectuted without any order.
 */
-(void)addBinder:(CREBinder*)childBinder;
-(void)removeBinder:(CREBinder*)childBinder;
-(void)removeFromSuperBinder;

#pragma mark - Binding
/**
 Binds all pairs. Sets self as observer for value changes of the source's keyPath.
 */
-(void)bind;

/**
 Removes previously added pair. Adds the pair argument and binds it.
 */
-(void)unbind;

/**
 The method within which the actual value merge/setting is taking place. Override this method to supply custom behavior. This method is called only if the delegate returns TRUE (if set) to the call binder:shouldSetValue:forKeyPath:.
 */

-(CREBindingTransaction*)createTransactionWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;


@end
