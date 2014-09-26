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


/**
 
 ## CREBinder Overview
 
 'CREBinder' is the class used to establish one or more bindings. It may hold other 'CREBinder' instances or instances of type 'CREBindRelation' (N.B.: actual bindings are encapsulated in CREBindRelation). Its main role is to provide an universal access to a set of binder/bindRelation instances relevant to a speicic context (e.g. viewController, flow, object etc.). The bind/unbind methods are thought to get called only on a CREBinder instance as this instance should provide the necessary context.
 
 ## Extension
 
  You may wish to extend this class in case a specific structure is needed or to include more detailed context. The 'CREBinder' implements a factory method that can be used for the creation of a CREBindRelation instance (CREBindRelationFactory). 
 
  As of 0.1, BindKit provides 3 layers that encapsulate different aspects of the data binding structure and execution flow:
    
    - CREBinder is holder / collection of binding related objects such as CREBindRelation and other sub-binder objects. Subclasses are expected to hold some contextual information/assumptions relevant to the structure of its bindings. The class on which the clients bind/unbind.
 
    - CREBindRelation represents an actual binding and is the class resposible for linking the objects and changing the values. If you'd want to modify that behavior, that is the place to do it.
 
    - CREBindingUnit is wrapper for an object and its property. CREBindRelation holds such objects.
 
 ## Use
 
  See below an example usage. You can use CREBinder to bind any kind of objects and not only views and models, as longs as they are KVO and KVC compliant.
 
     UITextField *aLabel = [[UITextField alloc] initWithFrame:aFrame]; //some frame
     Person *aPerson = [Person new]; //your model object
     CREBinder *aBinder = [CREBinder binderWithProperties:@[@“text”, @"name”]
                                            sourceObjects:@[aLabel, aPerson]]; // the order of the items in the arrays is very important and must match the property to object. Any suggestion on more understandable API would very be appriciated.
     
     [aBinder bind]; // now any changes to aPerson.name will be propagated to aLabel.text
 
    The default binding direction is bothways. That is, a change in one object's property will lead to change to all objects in the binding (i.e. the CREBindRelation instance).
 
 @see CREBindRelation, CREBindingUnit
 */


#import <UIKit/UIKit.h>
#import "CREBindRelation.h"
#import "NSError+BinderKit.h"
#import "CREBindProtocol.h"


@class CREBinder;

///----------------------------------------------------------
/// @name Creating CREBindRelation via CREBindRelationFactory
///----------------------------------------------------------

/**
 
 The 'CREBindRelationFactory' is an interface used to create instances of CREBindRelation. The CREBinder has a default implementation, but you also have the freedom to implement it as per your needs. If you'd like to implement your CREBindRelation classes you may also use the CREBinder implemenation for their creation to reduce your code's (concrete) dependencies (i.e. like factory method design pattern). Due to Apple's KVC, CREBinder does not need to know about your sub-classes of CREBindRelation, just create it by passing a string holding the name of your class.
    
    A possible usage:
 
    CREBinder *aBinder = [CREBinder new];
    CREBindRelation *myConcreteRelation = [aBinder createRelationWithProperties:propertiesArray 
                                                                  sourceObjects:objectsArray 
                                                                  relationClass:myClassName];
    [aBinder addRelation: myConcreteRelation];
    [aBinder bind];
 
 When a CREBinder is initilized with objects and properties, it uses this method to create the 'first' CREBindRelation, so if you'd want that modified you may consider subclassing CREBinder.

 @param className The className is the name of the class that needs creation. It must match exactly.
 
 @see CREBinder
 
 */

@protocol CREBindRelationFactory <NSObject>

-(CREBindRelation*)createRelationWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray relationClass:(NSString*)className;

@end


@interface CREBinder : NSObject <CREBindProtocol, CREBindRelationFactory>

@property (nonatomic, readonly) CREBinder * superBinder;
@property (nonatomic, readonly) NSArray * childBinders;
@property (nonatomic, readonly) NSArray * relations;

//TODO: unit test isLocked race condition
//@property (nonatomic, readonly) BOOL isLocked;
//TODO: unit test
@property (nonatomic, readonly) BOOL isBound;

#pragma mark - Initialization



+(instancetype)binderWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;
-(instancetype)initWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray;

#pragma mark - Setup
-(void)addRelation:(CREBindRelation*)bindRelation;
-(void)removeRelation:(CREBindRelation*)removeRelation;

-(void)addBinder:(CREBinder*)childBinder;
-(void)removeBinder:(CREBinder*)childBinder;
-(void)removeFromSuperBinder;





@end
