//
//  CREBindingUnit.h
//  BindKit
//
//  Created by Ivan Ivanov on 8/29/14.
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

@class CREBindRelation;
/**
 
 The smallest unit of abstraction, encapsulating a object, its property and context.
 
 */

@interface CREBindingUnit : NSObject

/**
 
 'CREBindingUnit' is initialiazed with an object and its property, that are to be subject to binding.
 
 */

-(instancetype)initWithObject:(id)object property:(NSString*)keyPath;


/**
 
 BindKit addresses the bound objects properties and values via the bindingUnit class. The client has access to the object, the property and the corresponding current value. Setting the wrapped object's property value directly is not supported.
 
 */

@property (nonatomic, readonly) id boundObject;
@property (nonatomic, readonly) id boundObjectProperty;
@property (nonatomic, weak) id value;

/**
 
 'relation' represents the bindRelation holding the bindingUnit.
 
 */


@property (nonatomic, weak) CREBindRelation *relation;

/**
 
 'isLocked'
 
 */


@property (nonatomic, readonly) BOOL isLocked;


-(BOOL)compareWithDict:(NSDictionary*)dictionary;

-(void)unlock;

@end
