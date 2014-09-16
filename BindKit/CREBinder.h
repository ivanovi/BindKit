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
#import "CREBindProtocol.h"

/**
 === General Information ===
 The binder class provides a one-to-one binding behavior for two objects (or more via additional one-to-one pairs) in both directions. It is set as observer for the values of both objects and serves as an additional layer. The instances can own other binders to account for more complex relations or multiple bindings in a given context.
 
 */

@class CREBinder;

#pragma mark - Binder delegate


@interface CREBinder : NSObject <CREBindProtocol>

//@property (nonatomic, weak) id <CREBinderDelegate> delegate;
@property (nonatomic, readonly) CREBinder * superBinder;
@property (nonatomic, readonly) NSArray * childBinders;
@property (nonatomic, readonly) NSArray * transactions; 
@property (nonatomic, readonly) BOOL isLocked;
@property (nonatomic, readonly) BOOL isBound;


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
-(void)removeTransaction:(CREBindingTransaction*)removingTransaction;

/**
 Adding and removing binders to the binder stack. In the general case they are exectuted without any order.
 */
-(void)addBinder:(CREBinder*)childBinder;
-(void)removeBinder:(CREBinder*)childBinder;
-(void)removeFromSuperBinder;

#pragma mark - Binding

-(CREBindingTransaction*)createTransactionWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;

@end
