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

@class CRERemoteBindingRelation;

typedef void (^CRERemoteBinderCallBack)(id newValue, CREBindingUnit *unit, NSError *error);



/**
 
 'CRERemoteBindingRelation' fetches data stored in JSON or image format stored remotely, based on a URL contained in one of the object's property (currently the property and object at index 0). It uses NSURLRequest and NSURLConnection APIs. RemoteBindingRelation is not responsible for the creation of the request. Instead, you can set it via the 'remoteRequest' property or provide a requestFactory as per 'CREBindRelationRequestDelegate'.
 
 
 You initialise the RemoteBindingRelation normally as any other bindRelation. However, the current implementation assumes that URL containing object/property is passed at index 0 of the properties and objects arrays. Like this:
 
 
 MYPictureModel *aPicture = [aPicture new]; // dummy imaginary model object having property 'urlString' and 'imageData'
 [aPicture setUrlString:@"http://someValidURL"];
 
 CREBinder *aBinder = [CREBinder new];
 
 // I want to bind the url property of aPicture to the imageData property of aPicture. This way everytime i set modify the url the RemoteBindingRelatio will fetch the binary data corresponding to the url. (performance can be be improved if there is a third property storing the url of the already downloaded image)
 
 CREBindRelation *remoteRelation = [aBinder createRelationWithProperties:propertiesArray
                                                           sourceObjects:objectsArray
                                                           relationClass:@"myRelationClassName"];
 
 
 
 
 //UIImageView *aView = [[UIImageView alloc] initWithFrame:aFrame];
 
 // now I want to bind the model object url with image propety of aView => i'll use value transformer
 
 
 
 
 
 
 
 */


@interface CRERemoteBindingRelation : CREBindRelation <CREBindRelationRequestDelegate>{

     NSURL *urlContainer;
}

@property (nonatomic, readwrite, copy) CRERemoteBinderCallBack callBack;
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
