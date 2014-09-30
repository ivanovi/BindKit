BindKit
=======

BindKit is a data binding library/framework for iOS by Ivan Ivanov, released under the MIT License. It requires ARC and works with KVC and KVO compliant classes.


Why use data binding?
=====================
Data binding is the pattern of linking two objects, so that changes are automatically propagated. It takes place mostly in establishing links between model and view objects. 

Data binding helps in achieving several goals, namely:
 - Enforcing the separation between views and models. 
   Altough this is normally done by the ViewController classes, in bigger projects there may be tendency to skip this midle layer so as to avoid dublication (of the KVO code). For example, if theres is a view showing the profile image of a user, "glueing" this relation (say between user.profileImage and the UIImageView's property image) will require KVO based implementations in every ViewController with such UI. To resolve this dublication we may pass a reference of the model object to the (custom) view, but then the view would not be reuseable and would dependent on the model class. With data binding this link is encapsulated separate and they do not need to know about each other. 
 
 - Linking objects reliably. Through binding the risk of stalled views or models is reduced. The code base becomes more testable.
 
 - Flexibility. The encapsulation of the binding improves flexibility in terms of structure and behavior. In terms of structure, it makes the ViewController classes smaller, thus more prone to re-use / extension. In terms of behavior, the linking and flow of data is modeled in dedicated set of classes, which allow values/links to be handled dynamically.

Data binding is not always the way to go. For example, a UITableView's uses UITableViewDataSource for getting its data - this serves the purpose to decouple the data from the TableView goes against the binding logic.


Key features of BindKit
=======================

The key features of BindKit:

- Created with the idea of extension. Three layers of abstraction allowing the modification of different aspects independently:

   - CREBinder represents a collection holding bindings (CREBindRelation) or other CREBinder classes. It may hold some additional contextual information.

   - CREBindRelation is the actual binding between objects properties. 

   - CREBindingUnit is wrapper over an object and its property that are subject to binding

- Multiple objects can be linked in one binding. It is not limited to a specific number or types of objects as long as they are KVO and KVC comliant.

- One direction (with source) or any direction binding (any object changes all objects in a binding)

- Bind to a remote resource. Bind a local property to a remote value via an URL. For example, an UIImageView's image property can bound to a model's property holding a URL, so that when that url value is changed the binder fetches an image. (N.B. This will be setup as an UIView category for convinience in next releases)

- Choose between static or dynamic (BindKit) target

HowTo-s?
========

- How to establish a simple binding:
```
     UITextField *aTextField = [[UITextField alloc] initWithFrame:aFrame]; //some frame
     Person *aPerson = [Person new]; //your model object
     
     CREBinder *aBinder = [CREBinder binderWithProperties:@[@“text”, @"name”]
                                            sourceObjects:@[aTextField, aPerson]]; // the order of the items in the arrays is very important and must match the property to object. 
     
     [aBinder bind]; // now any changes to aPerson.name will be propagated to aTextField.text
````

- How to use value transformers:
```
     MYCustomDateLabel *aLabel = [[MYCustomDateLabel alloc] initWithFrame:aFrame]; //some frame
     NewsFeedItem *item = [NewsFeedItem new]; //your model object
     
     CREBinder *aBinder = [CREBinder binderWithProperties:@[@“date”, @"timestamp”]
                                            sourceObjects:@[aLabel, item]]; // the order of the items in the arrays is very important and must match the property to object. 
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
 
         [remoteRelation setRequestFactory: [ServerClass defaultServer]] //some imaginary singleton server =>  handle authentication etc.
         [aBinder addRelation: remoteRelation];
         [aBinder bind]
```

Installation
============
There are many ways to add third party code to your project. I will present the one I believe is the easiest (yet not necessarily the perfect way):

1. Clone the repository to any convinient place locally (git clone https://github.com/ivanovi/BindKit.git)
2. Depending on your deployment target OS:

    iOS 8.0 or above:
    -------------------------
     a. Open the BindKit project
     
     b. Select the BindKit scheme (top left corner)
     
     c. Choose "iOS Device" as target device
     
     d. Press cmd+b to build BindKit (i.e.BindKit.framework)
     
     e. Close the BindKit Project 
     
     f. Open your project (the place you want to add BindKit to) and from finder drag the file BindKit.xcodeproj to your project. This will make BindKit a sub-project.
     
     g. Select your project and under targets choose your targe. Press the tab "General" and in the section "Embedded Binaries" the BindKit.framework target
     
     h. Import BindKit/BindKit.h whenever you need it (or add it to your prefix header)

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


