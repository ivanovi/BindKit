 //
//  CREBinder.m
//  BindKit
//
//  Created by Ivan Ivanov on 8/27/14.
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



#import "CREBinder.h"

@interface CREBinder(){
    
    NSMutableArray *relationsArray;
    
    NSMutableArray *childBinders;
    
}

@end

@implementation CREBinder


#pragma mark - Public Methods


+(instancetype)binderWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray{
    
    return [ [CREBinder  alloc] initWithProperties:propertiesArray sourceObjects:objectsArray];
}



-(instancetype)initWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray{
    
    NSAssert(propertiesArray, @"Properties must be passed as an array. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:104]);
    NSAssert(objectsArray, @"Objects must be passed as an array. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:104]);
    NSAssert(propertiesArray.count == objectsArray.count, @"Properties' array count is different from the objects' array count. %@", [NSError errorDescriptionForDomain:kCREBinderErrorSetupDomain code:104]);
    
    self = [super init];
    
    if (self)
    {
        relationsArray = [NSMutableArray new];
        
        CREBindRelation *initialRelation = [self createRelationWithProperties:propertiesArray sourceObjects:objectsArray relationClass:@"CREBindRelation"];
        [relationsArray addObject:initialRelation];
        
        _isBound = NO;
     
    }
    
    return self;
}


-(CREBindRelation*)createRelationWithProperties:(NSArray *)propertiesArray sourceObjects:(NSArray *)objectsArray relationClass:(NSString *)className{
    
    
    Class relationClass = NSClassFromString(className);
    
    if (!propertiesArray || !objectsArray)
    {
        
        return [relationClass new];
        
    }
    
    return [[relationClass alloc] initWithProperties:propertiesArray sourceObjects:objectsArray];
    
}


#pragma mark - Bind/unbind



-(void)bind{
    

    for (CREBindRelation *aRelation in relationsArray)
    {
        
        [aRelation bind];
        
    }
    
    
    for (CREBinder *subBinder in childBinders)
    {
        
        [subBinder bind];
        
    }
    
    _isBound = YES;
}




-(void)unbind{
    
    if (!_isBound)
    {
        return;
    }
    
    for (CREBindRelation *relation in relationsArray)
    {
        
        [relation unbind];
        
    }
    
    for (CREBinder *subBinder in childBinders)
    {
        
        [subBinder unbind];
        
    }
    
    _isBound = NO;
    
}



//-(void)bindPair:(NSArray *)pairArray{
//    
//    
//}
#pragma mark - Relations compositions

-(NSArray*)relations{
    
    if (relationsArray)
    {
        
        return [NSArray arrayWithArray:relationsArray];
        
    }
    return nil;
}


-(void)addRelation:(CREBindRelation *)bindRelation{
    
    
    if (!relationsArray)
    {
        
        relationsArray = [NSMutableArray new];
        
    }
    
    if (![relationsArray containsObject:bindRelation])
    {
        
        [relationsArray addObject:bindRelation];
        
    }
    
    
}

-(void)removeRelation:(CREBindRelation *)removeRelation{
    
    [relationsArray removeObject:removeRelation];
    
}




#pragma mark - Managing composites / child relations

-(void)addBinder:(CREBinder *)childBinder{
    
    
    if (!childBinders)
    {
        childBinders = [NSMutableArray new];
    }
    
    if (![childBinders containsObject:childBinder])
    {
        
        [childBinders addObject:childBinder];
        [childBinder performSelector:@selector(setSuperBinder:) withObject:self afterDelay:0];
    }
    
}

-(void)removeBinder:(CREBinder *)childBinder{
    
    [childBinders removeObject:childBinder];
    [childBinder removeFromSuperBinder];
}

-(void)removeFromSuperBinder{
    
    if (_superBinder) {
        
        [self performSelector:@selector(setSuperBinder:) withObject:nil afterDelay:0];
        
    }
}

-(NSArray*)childBinders{
    
    if (childBinders) {
        return [NSArray arrayWithArray:childBinders];
    }else{
        return nil;
    }
    
}

#pragma mark - Private methods

-(void)setSuperBinder:(CREBinder *)superBinder{
    
    if (![_superBinder isEqual:superBinder])
    {
        
        _superBinder = superBinder;
    
    }
    
    
}

-(id)objectInPairWithBoundObject:(id)boundObject mapKeys:(BOOL)shouldMapKey{
    
    //finds the object or a key in a pair bound with the boundObject argument
    
    __block id returnValue = nil;
    
    for (NSDictionary *bindingPairDictionary in relationsArray)
    {

        [bindingPairDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
           
            id compareObject = obj;
            if (shouldMapKey) {
                
                compareObject = key;
                
            }
            
            if (! [compareObject isEqual:boundObject] ) {
                
                returnValue = compareObject;
                *stop = YES;
                
            }

        }];
        
    }
    
    return returnValue;
}


-(void)dealloc{
    
    [self unbind];
    
}




@end
