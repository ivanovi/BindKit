//
//  CREValueTransformer.m
//  BindKit
//
//  Created by Ivan Ivanov on 9/17/14.
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

#import "CREValueTransformer.h"

@implementation CREValueTransformer

+(id <CREValueTransformerProtocol>)transformerWithName:(NSString *)transformerClassName{
    
    
    Class transformerClass = NSClassFromString(transformerClassName);
   
    NSAssert(transformerClass, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:1007]);
    NSAssert([transformerClass resolveClassMethod:@selector(bindRelation:willModify:withValue:)],
             @"%@. In class: %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:1006], transformerClass);
    
    return [NSClassFromString(transformerClassName)  new];
    
    
}


-(id)bindRelation:(CREBindRelation *)Relation willModify:(CREBindingUnit *)unit withValue:(id)value{
    // subclasses must override
    NSString *errorString = [NSString stringWithFormat:@"%@. In class: %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:1006], [self class]];
    
    @throw [NSException exceptionWithName:kCREBinderErrorSetupDomain reason: errorString userInfo:nil];
    
    return nil;
}

@end