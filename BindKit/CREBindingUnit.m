//
//  CREBindingUnit.m
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



#import "CREBindingUnit.h"

@implementation CREBindingUnit

//@synthesize value = _value;


-(instancetype)initWithObject:(id)object property:(NSString *)keyPath{
    NSAssert([keyPath isKindOfClass:[NSString class]], @"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:102]);
    NSAssert(object, @"%s %@",__PRETTY_FUNCTION__, [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:102]);
    
    self = [super init];
    
    if (self) {
        
        _boundObject = object;
        _boundObjectProperty = keyPath;

        if (![_boundObject isKindOfClass:[NSDictionary class]]) { //unit tests use dictionary
            
            @try
            {
                [_boundObject valueForKeyPath:_boundObjectProperty];
            }
            @catch (NSException *exception)
            {
                
                NSLog(@"%s %@",__PRETTY_FUNCTION__,[NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:102]);
                
                
            }
        }
    
    }
    
    return self;
}


-(BOOL)compareWithDict:(NSDictionary *)dictionary{
    
    __block BOOL comparisonResult = NO;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([key isEqual: _boundObjectProperty] ||
            [obj isEqual: _boundObject])
            comparisonResult = YES;
        
    }];
    
    return comparisonResult;
    
}

#pragma mark - Value accessors

-(id)value{
    
    return [_boundObject valueForKeyPath:(NSString*)_boundObjectProperty];
    
}

-(void)setValue:(id)value{
    
    @synchronized(value){
        
        if (![self.value isEqual:value] &&
            !_isLocked)
        {
            
            _isLocked = YES;
            [_boundObject setValue:value forKeyPath:_boundObjectProperty];
            
        }
        
        
    }
    
}


-(void)unlock{
    
    _isLocked = NO;
    
}
@end
