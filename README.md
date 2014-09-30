BindKit
=======

BindKit is a data binding library for iOS licensed under the MIT License. It requires ARC and works with KVC and KVO compliant classes.


Why use data binding?
=====================


Installation
============
There are many ways to add third party code to your project. I will present the one I believe is the easiest, yet not necessarily the best way:

1. Clone the repository to any convinient place locally (git clone git clone https://github.com/ivanovi/BindKit.git)
2. Depending on your deployment target OS:

    2.1. IF iOS 8.0 or above:
     a. Open the BindKit project
     b. Select the BindKit scheme (top left corner)
     c. Choose "iOS Device" as target device
     d. Press cmd+b to build BindKit (i.e.BindKit.framework)
     e. Close the BindKit Project 
     f. Open your project (the place you want to add BindKit to) and from finder drag the file BindKit.xcodeproj to your project. This will make BindKit a sub-project.
     g. Select your project and under targets choose your targe. Press the tab "General" and in the section "Embedded Binaries" the BindKit.framework target
     h. Use  #import <BindKit/BindKit.h> whenever you need it (or add it to your prefix header)

      
    2.2. IF 7.0 or above
    
     a. Open the BindKit project
     b. Select the BindKitStatic scheme (top left corner)
     c. Choose "iOS Device" as target device
     d. Press cmd+b to build libBindKitStatic.a 
     e. Close the BindKit Project 
     f. Open your project (the place you want to add BindKit to) and from Finder drag the file BindKit.xcodeproj to your project. This will make BindKit a sub-project.
     g. Select your project and choose your target. Go to "Build Phases" in the section "Target dependecies" add BindKitStatic and in the section "Link Binary With Libraries" and libBindKitStatic.a. If the header fielase cannot be found try adding "$(CONFIGURATION_BUILD_DIR)" to your "Header Search Paths" or the path of the target.
     h. Use  #import <BindKit/BindKit.h> whenever you need it (or add it to your prefix header)



Key features
============


HowTo-s?
========
