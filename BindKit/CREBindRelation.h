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
 
 This method is called only if the mandatory method returns 'bindRelation:shouldSetValue:forKeyPath:' YES or no delegate has been set. It does not interfere with the remaining execution. If the 'value' object is mutable you use this call to change it.
 
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

 //assuming you have declared some new class called MyValueTransformer
 
 CREBinder *aBinder = [CREBinder binderWithProperties:@[@“text”, @"name”]
                                        sourceObjects:@[aLabel, aPerson]];
 
 CREValueTransformer *numberDate = [CREValueTransformer transformerWithName:@"MyValueTransformer" ];
 [(CREBindRelation*)aBinder.relations.lastObject setValueTransformer: numberDate]; // after initialization
 [aBinder bind];
 
 */

-(id)bindRelation:(CREBindRelation*)relation willModify:(CREBindingUnit*)unit withValue:(id)value;

@end


/**
 'CREPlaceholderProtocol' provides placeholder value at the initial bind operation if no value has been available to any bindingUnit in a CREBindRelatiom. This method is called only once (at the 'bind' call) before adding the CREBindRelation as observer of notifications.
 
 */

@protocol CREPlaceholderProtocol <NSObject>

-(id)bindRelation:(CREBindRelation*)relation requiresPlaceholderValuesForUnit:(CREBindingUnit*)unit;

@end

/**
 
 'CREBinderRequestFactory' can be used for asynchronous data loading/reading. It is currently only called only in Remote Resource binding context.  A possible pattern is to set your server / networking operation classes to be a requestFactory; this can be done in a the factory method 'createRelationWithProperties:sourceObjects:relationClass:'.
 
 @see CRERemoteBindingRelation
 
 */

@protocol CREBinderRequestFactory <NSObject>

-(id)bindRelation:(CREBindRelation*)bindingRelation forURL:(NSURL*)url unit:(CREBindingUnit*)unit parameters:(NSDictionary*)params;

@end


@protocol CREBindRelationRequestDelegate <NSObject>

@property (nonatomic, weak) id <CREBinderRequestFactory> requestFactory;

@end


/**
 
Two binding directions are supported (in 0.1 version):
  
    - CREBindingRelationDirectionBothWays: Any object can have impact on the remaining object's properties in a bindRelation. That is, when an object's property is changed all remaining object's properties are changed accordingly. This is the default binding direction.
 
    - CREBindingRelationDirectionOneWay: One object's property is the source for the remaining objects. The transition to such configuration is done implicitly by seting one of the bindingUnits as source (@see setSourceBindingUnit:), this leads automatically to modifying the bindRelation's type to 'CREBindingRelationDirectionOneWay'. The

 
 */

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

/**
 
 'CREBindRelation' initialization follows the same logic as CREBinder with respect to the order of the objects and properties.
 
 @param propertiesArray Holds the names of the properties of objects as listed in the parameter 'objectsArray.' The order of the properties' names must match the order of the objects listed in 'objectsArray'. For example, a property at index 0 in 'propertiesArray' is declared in the object at index 0 of 'objectsArray'.
 
 @param objectsArray Holds a listing of the objects mapped against their properties in 'propertiesArray'.
 
 
 Example:
 
 //create a aBinder somewhere
 UILabel *aLabel = [[UILabel alloc] initWithFrame:aFrame];
 Person *aPerson = [Person new]; //an example model object
 
 CREBindRelation *aRelation = [[CREBindRelation alloc] initWithProperties:@[@“text”, @"name”] //name is a property of the class Person
                                                            sourceObjects:@[aLabel, aPerson]];
 [aBinder addRelation:aRelation];
 [aBinder bind];
 
 */

- (instancetype)initWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;

/**
 
 Adding an object's property to a CREBindiRelation is possible also as Dictionary, where the key represents the property name and the value the object.
 
 */

- (CREBindingUnit*)addBindingUnitWithDictionary:(NSDictionary*)propertyTargetDict;

/**
 
 You can add or remove more objects' properties via a bindingUnit instance.
 
 */

- (void)addBindingUnit:(CREBindingUnit*)subBindingUnit;
- (void)removeBindingUnit:(CREBindingUnit*)bindingUnit;


/**
 
 'setSourceBindingUnit:' sets the passed sourceUnit as a source and changes the direction type to one-way.
 
 @param sourceUnit This is the unit (an object's property wrapped in CREBindingUnit) that will modify the remaining bindingUnits in the bindRelation. It must have already been added to relation (@see addBindingUnit:).
 
 */

- (void)setSourceBindingUnit:(CREBindingUnit*)sourceUnit;


/**
 
 'removeSourceUnit' reverts the current's sourceUnit status to normal and changes the direction type to both-ways.
 
 */

- (void)removeSourceUnit;


/**
 
 The method where the modification of the values of the objects' properties in the bindRelation takes place. This method is called after the delegation has finished. You may override it in your implementation of CREBindRelation to supply a custom value modification.
 
 @param value The value to be used for modification.
 
 @param
 
 */

- (void)mergeValue:(id)value toTarget:(CREBindingUnit*)target;

@end
