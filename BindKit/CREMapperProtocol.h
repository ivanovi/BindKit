//
//  CREMapperProtocol.h
//  BindKit
//
///  Created by Ivan Ivanov on 9/16/14.
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

/**
 
 'CREMapperProtocol' establishes a mapping between two properties. As of version 0.1 the CREMapperProtocol is used only in CRERemoteBindingRelation. When a response from a remote API is received the 'remoteKeyForLocalKey:inLocalClass:' is called to establish which of the received (remote) keys from the response correspond to the local properties/keys. A real world implementation may take place in your model classes, where a mapping dictionary (localKey=>remoteKey) can be coded and consulted when needed.
 
 */

@protocol CREMapperProtocol <NSObject>

-(NSString*)remoteKeyForLocalKey:(NSString*)localKey inLocalClass:(NSString*)localClass;

@end
