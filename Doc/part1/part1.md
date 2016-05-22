# Chapter I: Designing our application with xCode

### Introduction to Apple's **Integrated Development Environment**: xCode

> Xcode includes everything developers need to create great applications for Mac, iPhone, iPad, Apple TV, and Apple Watch. Xcode provides developers a unified workflow for user interface design, coding, testing, and debugging. The Xcode IDE combined with the Cocoa frameworks and Swift programming language make developing apps easier and more fun than ever before.

* Launch `xCode` and create a new project with the menu **File/New/Project...** or by using the shortcut <kbd>CMD</kbd> + <kbd>SHIFT</kbd> + <kbd>N</kbd>
* Select the **Single View Application** from the **iOS/Application** menu
* Set up your project in the next view:
  * Product Name: name your project 
  * Organization Name: name your organization
  * Organization Identifier: a prefix used to create a bundle identifier for your project
  * Language: select **Swift**
  * Devices: select **Universal**
  * Do not check **Use Core Data**, **Include Unit Tests** and **Include UI Tests**, we won't use them for this project

xCode will bootstrap a basic template template for you, the environment can be seperated between 4 areas:

* The **Toolbar** allow you to manage your IDE, run and stop applications
* The **Navigator area** provides your several type of navigator, the **Project Navigator** is the one you will be using mainly and represent your project architecture tree.
* The **Editor area** is the place where you write your code.
* The **Utility area** provides the inspectors (assistant to manage your file or get some informations) and the libraries.

![illustration1](../art/illustration1.png)

### Cleaning up your project

The **project navigator** (in the navigator area) provides you a way to organize your project architecture. You can create folders and subfolders in your architecture tree and seperate your scripts as you wish. Let's start by seperating our files with the MVC pattern: <kbd>RIGHT CLICK</kbd> on the main folder in the **project navigator** and select the option "New Group" to create a new folder. Let's create 3 new folders: **Model**, **View** and **Controller**:

* Move the files **Main.storyboard**, **LaunchScreen.storyboard** and **Assets.xcassets** within your view folder
* Delete the default **ViewController.swift**
* Create a new file (<kbd>RIGHT CLICK</kbd> in the **project navigator** and select "New File...") **POIViewController.swift** in your **Controller** folder.

![illustration2](../art/illustration2.png)
