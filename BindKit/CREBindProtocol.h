//
//  CREBindProtocol.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/16/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

@protocol CREBindProtocol <NSObject>



/**
 Binds composite binders and transactions. Sets self as observer for value changes of the source's keyPath.
 */
-(void)bind;

/**
 Unbinds all observers. 
 */
-(void)unbind;


@end