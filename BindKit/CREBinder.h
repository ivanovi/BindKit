//
//  CREBinder.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+BinderKit.h"
/**
 
 The binder class provides a one-to-one binding behavior for two objects in both directions. The binder can support many pairs. It is set as observer for the values of both objects and server as an additional layer. The an example usage:
 
    UILabel *priceLabel = [UILabel new];
    [priceLabel setFrame:CGRectMake(0.0, 0.0, 50.0, 20.0)]
    
    NSMutableDictionary *someModelObject = [NSMutableDictionary dictionary];
 
    CREBinder *aBinder = [CREBinder binderWithMapping:@{@"modelTextPropertyName":@"text"}];
 
    [aBinder addPair: @[someModelObject, priceLabel] ];
    // add as much as you want pairs in one binder
 
    [aBinder bind];
 
 
 */

@class CREBinder;

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
@property (nonatomic, weak) CREBinder * superBinder;
@property (nonatomic, readonly) NSArray * childBindersArray;
@property (nonatomic, readonly) NSArray * pairs;
//@property (nonatomic, readonly, strong) NSDictionary *mappingDictonary; //the dictionary that sets the mapping structure. Set the property name

#pragma mark - Initialization
+(instancetype)binderWithMapping:(NSDictionary*)mapDictionary; //The dictionary that sets the mapping structure. Set the property name of one of the objects in a pair as key and the object as a value. This convinience method should be used only for one-to-one binding structure, for many-to-many, many-to-one, one-to-many use the dedicated CREBindingStructureDefinition class.

-(instancetype)initWithMapping:(NSDictionary*)mapDictionary;

#pragma mark - Setup

-(void)addPair:(NSDictionary*)objectsPair;
-(void)addBinder:(CREBinder*)childBinder;
-(void)removeBinder:(CREBinder*)childBinder;
-(void)removeFromSuperBinder;



#pragma mark - Binding
/**
 Binds all pairs, by setting self as observer for value changes of the source's keyPath. If
 */
-(void)bind;

/**
 Removes previously added pair. Adds the pair argument and binds it.
 */
//-(void)bindObjects:(NSArray*)pairingObjectsArray;

/**
 Undinds all pairs.
 */
-(void)unbind;

/**
 The within which the actual value merge is taking place. Override this method supply custom behavior. This method is called only if the delegate is set and it returns TRUE to the call binder:shouldSetValue:forKeyPath:.
 */
-(void)mergeValue:(id)value toTarget:(id)target withKeyPath:(NSString*)keyPath;

@end
