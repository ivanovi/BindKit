//
//  CREBindingDefinition.h
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
#import "CREBindingUnit.h"
#import "CREBindProtocol.h"

@class CREBindRelation;



@protocol CREBindRelationDelegate <NSObject>


-(BOOL)bindRelation:(CREBindRelation*)relation shouldSetValue:(id)value forKeyPath:(NSString*)keyPath;

@optional

-(void)bindRelation:(CREBindRelation*)relation willSetValue:(id)value forKeyPath:(NSString*)keyPath inObject:(id)targetObject;

@end


@protocol CREValueTransformerProtocol <NSObject>

-(id)bindRelation:(CREBindRelation*)relation willModify:(CREBindingUnit*)unit withValue:(id)value;

@end

@protocol CREPlaceholderProtocol <NSObject>

-(id)bindRelation:(CREBindRelation*)relation requiresPlaceholderValuesForUnit:(CREBindingUnit*)unit;

@end

@protocol CREBinderRequestFactory <NSObject>

-(id)bindRelation:(CREBindRelation*)bindingRelation forURL:(NSURL*)url unit:(CREBindingUnit*)unit parameters:(NSDictionary*)params;

@end

@protocol CREBindRelationRequestDelegate <NSObject>

@optional
@property (nonatomic, weak) id <CREBinderRequestFactory> requestFactory;

@end

typedef NS_ENUM(NSUInteger, CREBindingRelationDirection) {
    
    CREBindingRelationDirectionBothWays,
    CREBindingRelationDirectionOneWay,
    CREBindingRelationDirectionChained,
    
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
