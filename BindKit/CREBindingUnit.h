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

@class CREBindingTransaction;
/**
 
 The smallest unit of abstraction, encapsulating a object, its property and context.
 
 */

@interface CREBindingUnit : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)bindingMappingDictionary;

@property (nonatomic, weak) id boundObject;
@property (nonatomic, weak) id boundObjectProperty;
@property (nonatomic, weak) id remoteProperty;
@property (nonatomic, weak) id value;
@property (nonatomic, weak) CREBindingTransaction *transaction;

//@property (nonatomic, strong) NSDictionary *bindOptionsDictionary; // redo with enumeration

-(BOOL)compareWithDict:(NSDictionary*)dictionary;

@end
