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
 
 'CREBinder' is the class used to establish one or more bindings. It implements a composite-like pattern and may hold other 'CREBinder' instances or instances of type 'CREBindRelation'. In addition to providing an universal access to a set of binder/bindRelation instances,
 
 */


#import <UIKit/UIKit.h>
#import "CREBindRelation.h"
#import "NSError+BinderKit.h"
#import "CREBindProtocol.h"



@class CREBinder;

#pragma mark - Binder delegate


@protocol CREBindRelationFactory <NSObject>

-(CREBindRelation*)createRelationWithProperties:(NSArray*)propertiesArray sourceObjects:(NSArray*)objectsArray relationClass:(NSString*)className;

@end

@interface CREBinder : NSObject <CREBindProtocol, CREBindRelationFactory>

@property (nonatomic, readonly) CREBinder * superBinder;
@property (nonatomic, readonly) NSArray * childBinders;
@property (nonatomic, readonly) NSArray * relations;

//TODO: unit test isLocked race condition
@property (nonatomic, readonly) BOOL isLocked;
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
