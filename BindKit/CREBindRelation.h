//
//  CREBindRelation.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/28/14.
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
#import "NSError+BinderKit.h"
#import "CREBindProtocol.h"

/**
 
 ## CREBindRelation Overview
 
 The CREBindRelation class executes the actual linking and value transfer between bound objects and properties. It sets itself as an observer for KVO notifications, so that when a change in observed's object property occurs it gets a notification (as in KVO). The actual value transfer is handled in the 'mergeValue:toTarget:' method. The binding is effected via the 'bind' method and unbinding via the 'unbind' method (CREBindProtocol), called by the owning CREBinder instance.
 
 'CREBindRelation' holds CREBindingUnits which are just a wrapper of the object-property pair.
 
 ## Configuration
 
To an CREBindRelation you can add or remove CREBindingUnits, set a sourceUnit (this implies a one-way setup), or add/remove objects that implement the delegate interfaces/functionality. 
 
 ## Extension
 
The main entry point for extension is the 'mergeValue:toTarget:' method. It is called after all delegate methods.
 
 */

@class CREBindRelation, CREBindingUnit;


///----------------------------------------------------------
/// @name CREBindRelationDelegate Protocol
///----------------------------------------------------------

/**
 
 ## Purpose
 
 'CREBindRelationDelegate' provides hooks for inserting dynamic behavior within delegate methods. Both methods are called after a KVO notification about a value change (within the 'observeValueForKeyPath:ofObject:change:context:' implementation). The mandatory method is called before the optional method.
 
 */


@protocol CREBindRelationDelegate <NSObject>

/**
 
 @param relation This the relation which has received the KVO notification.
 @param value The new value that has been set with the observed object and property.
 @param keyPath The keypath that has been changed.
 
 @return A BOOL value indicating whether the CREBindRelation instance should proceed and change the values of the remaining objects' properties. If YES is returned the execution continues and values are changed with the 'value' parameter. If NO is returned, the execution does not proceed to change of the properties of remaining objects. The default implementation is set YES (i.e. no delegate set).
 
 
 */

-(BOOL)bindRelation:(CREBindRelation*)relation shouldSetValue:(id)value forKeyPath:(NSString*)keyPath;

@optional

/**
 
 This method is called only if the mandatory method returns YES or no delegate has been set. It does not interfer the remaining execution. If the value object is mutable it may be changed.
 
 */

-(void)bindRelation:(CREBindRelation*)relation willSetValue:(id)value forKeyPath:(NSString*)keyPath inObject:(id)targetObject;

@end


@protocol CREValueTransformerProtocol <NSObject>

/**
 
 Provides the option to change the value just before it is set. N.B. : It is called in the 'mergeValue:toTarget:', so if you'd like to preserve this delegation you could call super or match the functionality. BindKit provides off-the-shelf value transformers that can be used directly via the convienence factory method of 'CREValueTransformer' - 'transformerWithName:'.
 
 @param relation This the relation which has received the KVO notification.
 @param unit The bindingUnit that is going to be addressed with setValue: 
 @param value The actual value that is intented for setting the new value of object's property presented by the CREBindingUnit (unit).

 @return The modified/tranformed value after the corresponding transformation has been made.
 
 Example - Existing Value Transformers:
 
 
 CREBinder *aBinder = [CREBinder binderWithProperties:@[@“text”, @"name”]
                                        sourceObjects:@[aLabel, aPerson]];
 
 CREValueTransformer *numberDate = [CREValueTransformer transformerWithName:@"CRENumberDateTransformer" ];
 [(CREBindRelation*)aBinder.relations.lastObject setValueTransformer: numberDate]
 [aBinder bind];
 
 
 Example - Your Value Transformers:

 --- assuming you have declared and implemented MyValueTransformer
 
 CREBinder *aBinder = [CREBinder binderWithProperties:@[@“text”, @"name”]
                                        sourceObjects:@[aLabel, aPerson]];
 
 CREValueTransformer *numberDate = [CREValueTransformer transformerWithName:@"MyValueTransformer" ];
 [(CREBindRelation*)aBinder.relations.lastObject setValueTransformer: numberDate]
 [aBinder bind];
 
 */

-(id)bindRelation:(CREBindRelation*)relation willModify:(CREBindingUnit*)unit withValue:(id)value;

@end

@protocol CREPlaceholderProtocol <NSObject>


/**
 'CREPlaceholderProtocol' provides capability for providing a placeholder value if at initial bind operation no value has been available. This method is called only at the 'bind' call and before adding the CREBindRelation as observer of notifications.
 
 */

-(id)bindRelation:(CREBindRelation*)relation requiresPlaceholderValuesForUnit:(CREBindingUnit*)unit;

@end

@protocol CREBinderRequestFactory <NSObject>

/**
 'CREPlaceholderProtocol' provides capability for providing a placeholder value if at initial bind operation no value has been available. This method is called only at the 'bind' call and before adding the CREBindRelation as observer of notifications.
 
 */

-(id)bindRelation:(CREBindRelation*)bindingRelation forURL:(NSURL*)url unit:(CREBindingUnit*)unit parameters:(NSDictionary*)params;

@end

@protocol CREBindRelationRequestDelegate <NSObject>

@optional
@property (nonatomic, weak) id <CREBinderRequestFactory> requestFactory;

@end

typedef NS_ENUM(NSUInteger, CREBindingRelationDirection) {
    
    CREBindingRelationDirectionBothWays,
    CREBindingRelationDirectionOneWay,
    
};


@interface CREBindRelation : NSObject <CREBindProtocol>{
    
     CREBindingUnit * sourceUnit;
    
}
@property (nonatomic, readonly) NSArray * bindingUnits; //immediate/current units
@property (nonatomic, readonly) CREBindingRelationDirection directionType;
@property (nonatomic, weak) id <CREValueTransformerProtocol> valueTransformer;
@property (nonatomic, weak) id <CREPlaceholderProtocol> placeholder; 
@property (nonatomic, weak) id <CREBindRelationDelegate> delegate;
@property (nonatomic, readonly) CREBindingUnit *sourceUnit;
//TODO: unit test isLocked - race condition
@property (nonatomic, readonly) BOOL isLocked;
@property (nonatomic, readonly) BOOL isBound;

- (instancetype)initWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;

- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict; //key => represents the property ; value => the instance
- (void)addBindingUnit:(CREBindingUnit*)subBindingUnit;
- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit;

- (void)setSourceBindingUnit:(CREBindingUnit*)sourceUnit;
- (void)removeSourceUnit;

- (void)mergeValue:(id)value toTarget:(CREBindingUnit*)target;

@end
