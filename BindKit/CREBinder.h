//
//  CREBinder.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
//  Copyright (c) 2014 Ivan Ivanov, Creatub Ltd.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.



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
