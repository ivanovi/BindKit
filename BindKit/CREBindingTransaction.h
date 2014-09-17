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

@class CREBindingTransaction;



@protocol CREBindTransactionDelegate <NSObject>


-(BOOL)bindTransaction:(CREBindingTransaction*)transaction shouldSetValue:(id)value forKeyPath:(NSString*)keyPath;

@optional

-(void)bindTransaction:(CREBindingTransaction*)transaction willSetValue:(id)value forKeyPath:(NSString*)keyPath inObject:(id)targetObject;

@end


@protocol CREValueTransformerProtocol <NSObject>

-(id)bindTransaction:(CREBindingTransaction*)transaction willModify:(CREBindingUnit*)unit withValue:(id)value;

@end

@protocol CREPlaceholderProtocol <NSObject>

-(id)bindTransaction:(CREBindingTransaction*)transaction requiresPlaceholderValuesForUnit:(CREBindingUnit*)unit;

@end

typedef NS_ENUM(NSUInteger, CREBindingTransactionDirection) {
    
    CREBindingTransactionDirectionBothWays,
    CREBindingTransactionDirectionOneWay,
    CREBindingTransactionDirectionChained,
    
};


@interface CREBindingTransaction : NSObject <CREBindProtocol>{
    
     CREBindingUnit * sourceUnit;
    
}


//@property (nonatomic, readonly) NSSet * boundObjects;
//@property (nonatomic, readonly) NSSet * keys;
@property (nonatomic, readonly) NSArray * bindingUnits; //immediate/current units
@property (nonatomic, readonly) CREBindingTransactionDirection directionType;
@property (nonatomic, weak) id <CREValueTransformerProtocol> valueTransformer;
@property (nonatomic, weak) id <CREPlaceholderProtocol> placeholder;
@property (nonatomic, weak) id <CREBindTransactionDelegate> delegate;
@property (nonatomic, readonly) CREBindingUnit *sourceUnit;
@property (nonatomic, readonly) BOOL isLocked;
@property (nonatomic, readonly) BOOL isBound;

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


-(void)setValue:(id)value forObject:(id)object withKeypath:(NSString*)keyPath;

@end
