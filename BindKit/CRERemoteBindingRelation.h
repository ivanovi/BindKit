//
//  CRERemoteBindingRelation.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/2/14.
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


#import "CREBindRelation.h"
#import "CREMapperProtocol.h"



/**
 
 'CRERemoteBindingRelation' fetches data stored in JSON or image format from a remote host, based on an URL contained in one of the objects' property (assumed at index 0). It uses NSURLRequest and NSURLConnection APIs. 'RemoteBindingRelation' is not responsible for the creation of the request. Instead, you can set it via the 'remoteRequest' property or provide a requestFactory as per 'CREBindRelationRequestDelegate'.
 
 
 You initialise the RemoteBindingRelation normally as any other bindRelation. However, the URL containing object/property must be passed at index 0 of the properties and objects arrays, as shown in the example below. Alternatively you may set one of the bindingUnits as a source.
 
 
         MYPictureModel *aPicture = [aPicture new]; // dummy imaginary model object having property 'urlString' and 'imageData'
         [aPicture setUrlString:@"http://someValidURL"];
         
         CREBinder *aBinder = [CREBinder new];
         CREBindRelation *remoteRelation = [aBinder createRelationWithProperties:@[@"urlString",@"imageData"]
                                                                   sourceObjects:@[aPicture, aPicture]
                                                                   relationClass:@"CRERemoteBindingRelation"];
 
         [remoteRelation setRequestFactory: [ServerClass defaultServer]] //some imaginary singleton server => he can handle authentication etc.
         [aBinder addRelation: remoteRelation];
         [aBinder bind]
         
 This above relation will now fetch the binary data of the image everytime the 'urlSting' value changes.
 
 If you'd want to bind aPicture object from the above's example to an UIImage property, you may use the value transformers, like this:
 
 CREValueTransformer *dataToImage = [CREValueTransformer transformerWithName:@"CREDataImageTransformer"]; //note that 'valueTransformer' is weak property
 [remoteRelation setValueTransformer: dataToImage];
 
 */


@class CRERemoteBindingRelation;


typedef void (^CRERemoteBinderCallBack)(id newValue, CREBindingUnit *unit, NSError *error);

@interface CRERemoteBindingRelation : CREBindRelation <CREBindRelationRequestDelegate>{

     NSURL *urlContainer;
}
/**
 
 'callBack' is called after a response from the remote host has been recevied.
 
 */
@property (nonatomic, readwrite, copy) CRERemoteBinderCallBack callBack;

/**
 @see CREMapperProtocol
 */

@property (nonatomic, weak) id <CREMapperProtocol> remoteKeyMapper;
@property (nonatomic, strong) id remoteRequest;


-(id)requestWithRequest:(id)request;
-(void)executeRequest:(id)request withCallBack:(void (^)(NSURLResponse *response,
                                                         NSData *data,
                                                         NSError *connectionError)) completionHandler;

-(void)assertSource;
-(void)assertRequest:(id)request;

-(void)setValue:(id)value forUnit:(CREBindingUnit*)bindingUnit;

@end
