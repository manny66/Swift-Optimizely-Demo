# Swift-Optimizely-Demo
This is a fully functioning Swift 5 app that uses the Fullstack product to run both a Feature Rollout and A/b test.
The app structure follows the [MVC framework](https://www.raywenderlich.com/1000705-model-view-controller-mvc-in-ios-a-modern-approach) and has the following dependencies installed via Cocoapods:
- OptimizelySwiftSDK
- SwipeCellKit
- RealmSwift

## What does the app do?
Using [Realm DB](https://realm.io/blog/introducing-realm/), it persists a list of TSEs locally to the device and each tse record when clicked will transition to a second view which persists a list of "todo" Tasks shown for that particular TSE.

Initially it should generate a list of TSE records when you first run the app.

![image](https://user-images.githubusercontent.com/36277912/82411117-825ac900-9ab4-11ea-9652-05e4f583ae0e.png)

The app includes functionality such as:
- Adding new TSEs
- Deleting TSEs (feature rollout)
- Creating Tasks
- Checkmarking Tasks
- Searching for Tasks (A/b test)

## Installation of project repo
1. Install Xcode
2. Get clone app URL from rep
3. In xcode click on new project clone and enter URL
4. Save it to a directory on your machine
5. Close xcode and open the file "TSE Profiler.xcworkspace" in the root folder (do not use the .xcodeproj file)
6. Click on the play button on the top left hand corner of xcode (this will build the app)
7. There are 3 dependency packages used in the App via cocoapods so it may take a couple of minutes to build
8. After app is finished building, it will run the simulator and let you interact with the app

## Main files in the project and what they do

![image](https://user-images.githubusercontent.com/36277912/82416312-28123600-9abd-11ea-9f21-aea77b311797.png)

## Swift SDK Installation
We are using the cocoapod dependency package manager to install the SDK.
This has already been done as per instructions in our [KB linked here](https://docs.developers.optimizely.com/full-stack/docs/install-sdk-swift#section-cocoapods).

## Optimizely Initialisation
The Optimizely initialisation is done in the file [AppDelegate.swift](https://github.com/manny66/Swift-Optimizely-Demo/blob/master/TSE%20Profiler/AppDelegate.swift) which is found in the root folder. This file is present in all Swift apps and is where a lot of the application lifecycle events happens.

```swift
    let optimizely = OptimizelyClient(sdkKey: "QQJNMaYs9cLijynKsDme4o", periodicDownloadInterval: 60)
```

We also are using a bundled datafile which is stored in [localDatafile.json](https://github.com/manny66/Swift-Optimizely-Demo/blob/master/TSE%20Profiler/Supporting%20Files/localDatafile.json). This allows it to run Synchronously by using this local file, and then using the updated datafile which is requested every 60 seconds.

```swift
  if let localDatafilePath = Bundle.main.path(forResource: "localDatafile", ofType: "json") {
            
            do {
                let datafileJSON = try String(contentsOfFile: localDatafilePath, encoding: .utf8)
                try optimizely.start(datafile: datafileJSON)
                
                print("Optimizely SDK initialized successfully!")
            } catch {
                print("Optimizely SDK initiliazation failed: \(error)")
            }
```

Most of the Optimizely execution such as activation, getting the feature, getting the variation, tracking etc happens in the file [OptimizelyStuff.swift](https://github.com/manny66/Swift-Optimizely-Demo/blob/master/TSE%20Profiler/Models/OptimizelyStuff.swift) found in the Models folder. This is also where the userID and role attribute are set. To see the rollouts feature, simply change the role value in this file to "manager" or any other string if you want to disable the feature.

```swift
    let role = "manager"
    let userId = "bill"               
```

## Feature Rollout usage
The rollout allows users who have the "manager" role to delete a TSE record via the swipe left functionality, as well as add new TSEs via the add icon. You can find the evaluation of this in the file SwipeViewController.swift under the Controllers folder. 

```swift
    // Only allow deletion feature if rollout feature enabled returns true
    if feature.getFeature(key: "managerfunctionality") {
        cell.delegate = self
    }
```

## A/b test activation and usage
The experiment controls who can view the search bar on the TSE Tasks page.

We activated the experiment as soon as the first view appears which is managed by TSEListViewController.swift

```swift
        // activate experiment
        _ = optimizelyStuff.expActivate(key: "search_bar")
```        
        
The variations are evaluated when the subsequent view is loaded which is managed by TSETaskViewController.swift

```swift
   // runs when view appears
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // enable search bar if "SearchBar" variation was given
        if let variation = optimizelyStuff.expVariation(key: "search_bar") {
            if variation == "SearchBarTrue" {
                searchBar.isHidden = false
            }
        }
    }
```        

In the same file, we also use Optimizely track() to send conversions when search is used 

```swift
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // trigger optimizely event when search is performed
        optimizelyStuff.triggerEvent(event: "used_search")
        
        // filter realm "tasks" objects with search bar text and do an asc sort on title key
        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "created", ascending: true)
        
        // reload table with filtered data
        tableView.reloadData()
    }
```        

