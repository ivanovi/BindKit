//
//  CRESocialServicesRelation.h
//  BindKit
//
//  Created by Ivan Ivanov on 9/17/14.
//  Copyright (c) 2014 Creatub Ltd. All rights reserved.
//

#import <BindKit/BindKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "CRERemoteBindingRelation.h"

/**
 
 'CRESocialServicesRelation' is an extenstion of remoteBindingRelation used for communication with social APIs supported natively by Apple's API, like
  
    - facebook
    - twitter
    - weibo etc.
 
 
 You use like remoteBindingRelation, yet instead you supply a valid SLRequest (not a NSURLRequest) from your 'requestFactory'.
 
 
 
 */

@interface CRESocialServicesRelation : CRERemoteBindingRelation

@end
