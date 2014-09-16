//
//  CREBindProtocol.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/16/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

@protocol CREBindProtocol <NSObject>



/**
 Binds all pairs. Sets self as observer for value changes of the source's keyPath.
 */
-(void)bind;

/**
 Removes previously added pair. Adds the pair argument and binds it.
 */
-(void)unbind;


@end