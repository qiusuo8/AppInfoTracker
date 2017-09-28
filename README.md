<p align="center">
<a href="https://travis-ci.org/qiusuo8/AppInfoTracker"><img src="https://img.shields.io/travis/qiusuo8/AppInfoTracker/master.svg"></a>
<!--<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
--><a href="http://qiusuo8.github.io/AppInfoTracker/"><img src="https://img.shields.io/cocoapods/v/AppInfoTracker.svg?style=flat"></a>
<a href="https://raw.githubusercontent.com/onevcat/Kingfisher/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/Kingfisher.svg?style=flat"></a>
<a href="http://qiusuo8.github.io/AppInfoTracker/"><img src="https://img.shields.io/cocoapods/p/AppInfoTracker.svg?style=flat"></a>
</p>

AppInfoTracker is a lightweight, pure-Swift library for tracking times of start app and excute block when first launch for certain version or build of today. This project is inspired by [VersionTrackerSwift](https://github.com/tbaranes/VersionTrackerSwift).

## Requirements

- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Swift 3

Main development of AppInfoTracker will support Swift 3.

## Usage

In your ApplicationDelegate, call the method `track` to track the current version:

```swift
	// iOS / tvOS
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AppInfoTracker.track()
        return true
    }
```

```swift
	// OS X
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        AppInfoTracker.track()
        return true        
    }

```

Then, call whenever one of the following methods to get the data you need:

```swift
isFirstLaunchOfToday: Bool
isFirstLaunchForCurrentVersion: Bool
isFirstLaunchForCurrentVersionAndBuild: Bool

versionHistory: [String]

public static func isFirstLaunchForVersion(_ version: String, firstLaunchCompletion: (() -> Void)? = nil) -> Bool

public class func isFirstLaunchForVersion(_ version: String, build: String, firstLaunchCompletion: (() -> Void)? = nil) -> Bool

public class func isFirstLaunchForToday(firstLaunchCompletion: (() -> Void)? = nil) -> Bool

public class func currentVersion() -> String

public class func previousVersion() -> String?

public class func currentBuild() -> String

public class func numbersOfStartupsForVersion(_ version: String) -> Int

public class func numbersOfStartupsForVersion(_ version: String, build: String) -> Int

public class func numbersOfStartupsForToday() -> Int


```
 
## Installation

### CocoaPods

Add the following line in your Podfile:

```
pod 'AppInfoTracker'
```

## Contribution

If you find an issue, just [open a ticket](https://github.com/qiusuo8/AppInfoTracker/issues/new). Pull requests are warmly welcome as well.


## Licence

Kingfisher is released under the MIT license. See LICENSE for details.


