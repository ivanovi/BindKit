BindKit
=======

BindKit is a data binding library/framework for iOS by Ivan Ivanov, released under the MIT License. It requires ARC and works with Key Value Coding and Key Value Observer compliant classes.


Why use data binding?
=====================
Data binding is the pattern of linking two objects, so that changes are automatically propagated. It is used mostly for establishing links between model and view objects. 

Data binding helps in achieving several goals, namely:
 - Enforcing the separation between views and models. 
   Although this task is normally performed by the ViewController classes, in larger projects there may be tendency to skip the middle layer in order to avoid duplication (of the KVO code). For example, consider a view showing the profile image of a user, "glueing" this relation (say between user.profileImage and an UIImageView's property "image") will require KVO based implementations in every ViewController containing the view. To resolve this, we may pass a reference of the model object to the (custom profile image) view, but then the view would dependent on the model class. With data binding this link is encapsulated separately and both elements do not need to know about each other. 
 
 - Linking objects reliably. Through binding the risk of stalled views or models is reduced. The code becomes more testable.
 
 - Flexibility. The encapsulation of the binding improves flexibility in terms of structure and behavior. In terms of structure, it makes the ViewController classes smaller (and easier to reuse or extend). In terms of behavior, it allows value assignment and linking to be handled dynamically.

Data binding is not always the way to go, yet. There are situations in which, it is not appropriate to bind objects. For example, UITableView uses the UITableViewDataSource protocol for getting its data - this decouples the presented data from the TableView and goes against the binding logic. As always, it depends on your overall design, style or preferences whether you will use data binding.


Key features of BindKit
=======================

The key features of BindKit:

- Created with the idea of extension. Three layers of abstraction allowing the modification of different aspects of the binding independently:

   - CREBinder represents a collection like class, which holds bindings (CREBindRelation) or other CREBinder instances. It may hold some additional contextual information (if extended).

   - CREBindRelation is the actual binding between objects' properties. 

   - CREBindingUnit is wrapper over an object and its property.

- Multiple objects can be linked in one binding. It is not limited to a specific number or types of objects as long as they are KVO and KVC compliant. 

- One direction (with one source object property) or any direction binding (any object changes all objects in a binding)

- Bind to a remote resource. Bind a local property to a remote value via an URL. For example, an UIImageView's image property can bound to a model's property holding a URL, so that when that url value is changed the binder fetches an image. (N.B. This will be setup as an UIView category for convinience in next releases)

- Choose between static or dynamic (BindKit) target

HowTo-s?
========

- How to establish a simple binding:
```
     UITextField *aTextField = [[UITextField alloc] initWithFrame:aFrame]; //some frame you assigned before
     Person *aPerson = [Person new]; //example model object
     
     CREBinder *aBinder = [CREBinder binderWithProperties:@[@“text”, @"name”]
                                            sourceObjects:@[aTextField, aPerson]]; // the order/index of the items in the arrays is important and must match the property with object object. 
     
     [aBinder bind]; // now any changes to aPerson.name will be propagated to aTextField.text
```

- How to use value transformers:
```
     MYCustomDateLabel *aLabel = [[MYCustomDateLabel alloc] initWithFrame:aFrame]; //some frame
     MYNewsFeedItem *item = [NewsFeedItem new]; //your model object
     
     CREBinder *aBinder = [CREBinder binderWithProperties:@[@“date”, @"timestamp”]
                                            sourceObjects:@[aLabel, item]]; // the order/index of the items in the arrays is important and must match the property with object object. 
    CREValueTransformer *aDateTransformer = [CREValueTransformer transformerWithName:@"CRENumberDateTransformer"];
    [aBinder.relations.lastObject setValueTransformer:aDateTransformer]; // NSNumber unix timestamp to NSDate object
    [aBinder bind]; 
```
- How to bind to remote resource:

```
         MYPictureModel *aPicture = [aPicture new]; // dummy imaginary model object having property 'urlString' and 'imageData'
         [aPicture setUrlString:@"http://someValidURL"];

         CREBinder *aBinder = [CREBinder new];
         CREBindRelation *remoteRelation = [aBinder createRelationWithProperties:@[@"urlString",@"imageData"]
                                                                   sourceObjects:@[aPicture, aPicture]
                                                                   relationClass:@"CRERemoteBindingRelation"];
 
         [remoteRelation setRequestFactory: [ServerClass defaultServer]] //some imaginary singleton server =>  creates the request with or without token etc.
         [aBinder addRelation: remoteRelation];
         [aBinder bind]
```

Installation
============
There are many ways to add third party code to your project. I will present the one I believe is the easiest (yet not necessarily the perfect) way:

1. Clone the repository to any convinient place locally (git clone https://github.com/ivanovi/BindKit.git)
2. Depending on your deployment target:

    iOS 8.0 or above:
    -------------------------
     a. Open the BindKit project
     
     b. Select the BindKit scheme (top left corner)
     
     c. Choose "iOS Device" as a target device
     
     d. Press cmd+b to build BindKit (i.e. resulting in the product BindKit.framework)
     
     e. Close the BindKit Project 
     
     f. Open your project (the place you want to add BindKit to) and from Finder drag the file BindKit.xcodeproj to your project. This will make BindKit a sub-project to your project. 
     
     g. Select your project and under targets choose your target. Press the tab "General" and in the section "Embedded Binaries" add BindKit.framework
     
     h. In your code, import BindKit/BindKit.h whenever you need it. If your are using Swift, you may consider including it in your Bridge-header.

    iOS 7.0 or above
    ----------------
     a. Open the BindKit project
     
     b. Select the BindKitStatic scheme (top left corner)
     
     c. Choose "iOS Device" as target device
     
     d. Press cmd+b to build libBindKitStatic.a
     
     e. Close the BindKit Project
     
     f. Open your project (the place you want to add BindKit to) and from Finder drag the file BindKit.xcodeproj to your project. This will make BindKit a sub-project.
     
     g. Select your project and choose your target. Go to "Build Phases". In the section "Target dependecies" add BindKitStatic and in the section "Link Binary With Libraries" and libBindKitStatic.a. If the header files still cannot be found try adding "$(CONFIGURATION_BUILD_DIR)" to your "Header Search Paths" (in the Build Settings tab) or the path of the target.
     
     h. Import BindKit/BindKit.h whenever you need it (or add it to your prefix header)


