//
//  AppInfoTracker.swift
//  AppInfoTracker
//
//  Created by zhaozh on 2017/7/21.
//  Copyright © 2017年 qiusuo8. All rights reserved.
//

import Foundation

fileprivate enum TrackerKey: String {
    case versionMap = "AppInfoTracker-version"
    case versionHistory = "AppInfoTracker-version-h"
    case dayLaunch = "AppInfoTracker-dayLaunch"
}

public class AppInfoTracker {
    
    public typealias FirstLaunchClosure = () -> Void
    
    public fileprivate(set) var isFirstLaunchForCurrentVersion: Bool = false
    public fileprivate(set) var isFirstLaunchForCurrentVersionAndBuild: Bool = false
    
    public fileprivate(set) var isFirstLaunchOfToday: Bool = false

    public static let shared = AppInfoTracker()
    
    public fileprivate(set) var versionHistory: [String] = []
    fileprivate var versionMap: [String: [String: Int]] = [:]
    
    fileprivate var dayLaunchMap: [String: Int] = [:]
    
    fileprivate var todayId: String {
        let dateString = AppInfoTracker.dayFormatter.string(from: Date())
        return dateString
    }
    
    fileprivate static var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private init() {
        if let versionMap = UserDefaults.standard.dictionary(forKey: TrackerKey.versionMap.rawValue) as? [String: [String: Int]] {
            self.versionMap = versionMap
        }
        if let versionHistory = UserDefaults.standard.stringArray(forKey: TrackerKey.versionHistory.rawValue) {
            self.versionHistory = versionHistory
        }
        if let dayLaunchMap = UserDefaults.standard.dictionary(forKey: TrackerKey.dayLaunch.rawValue) as? [String: Int] {
            self.dayLaunchMap = dayLaunchMap
        }
    }
    
    // MARK: - Tracker
    public class func track() {
        shared.startTracking()
    }
    
    // MARK: - First Launch
    public static func isFirstLaunchForVersion(_ version: String, firstLaunchCompletion: FirstLaunchClosure? = nil) -> Bool {
        let currentVersion = AppInfoTracker.currentVersion()
        let count = numbersOfStartupsForVersion(version)
        
        let isFirstLaunch: Bool = (count == 1 && currentVersion == version)
        if let closure = firstLaunchCompletion, isFirstLaunch == true {
            closure()
        }
        return isFirstLaunch
    }
    
    public class func isFirstLaunchForVersion(_ version: String, build: String, firstLaunchCompletion: FirstLaunchClosure? = nil) -> Bool {
        let currentVersion = AppInfoTracker.currentVersion()
        let currentBuild = AppInfoTracker.currentBuild()
        let count = numbersOfStartupsForVersion(version, build: build)
        
        let isFirstLaunch: Bool = (count == 1 && currentVersion == version && currentBuild == build)
        if let closure = firstLaunchCompletion, isFirstLaunch == true {
            closure()
        }
        return isFirstLaunch
    }
    
    public class func isFirstLaunchForToday(firstLaunchCompletion: FirstLaunchClosure? = nil) -> Bool {
        let count = numbersOfStartupsForToday()
        let isFirstLaunch: Bool = (count == 1)
        if let closure = firstLaunchCompletion, isFirstLaunch == true {
            closure()
        }
        return isFirstLaunch
    }
    
    // MARK: - Info
    public class func currentVersion() -> String {
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        if let version = currentVersion as? String {
            return version
        }
        return ""
    }
    
    public class func previousVersion() -> String? {
        guard shared.versionHistory.count >= 2 else {
            return nil
        }
        return shared.versionHistory[shared.versionHistory.count - 2]
    }
    
    public class func currentBuild() -> String {
        let currentBuild = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String)
        if let build = currentBuild as? String {
            return build
        }
        return ""
    }
    
    // MARK: - numbers of start app
    public class func numbersOfStartupsForVersion(_ version: String) -> Int {
        if let buildMap = shared.versionMap[version] {
            var sum = 0
            for (_, value) in buildMap {
                sum += value
            }
            return sum
        }
        return 0
    }
    
    public class func numbersOfStartupsForVersion(_ version: String, build: String) -> Int {
        if let buildMap = shared.versionMap[version] {
            if let count = buildMap[build] {
                return count
            }
        }
        return 0
    }
    
    public class func numbersOfStartupsForToday() -> Int {
        if let num = shared.dayLaunchMap[shared.todayId] {
            return num
        }
        return 0
    }
}

extension AppInfoTracker {
    
    fileprivate func startTracking() {
        updateFirstLaunchForVersion()
        updateFirstLaunchForToday()
        
        isFirstLaunchForCurrentVersion = AppInfoTracker.isFirstLaunchForVersion(AppInfoTracker.currentVersion())
        isFirstLaunchForCurrentVersionAndBuild = AppInfoTracker.isFirstLaunchForVersion(AppInfoTracker.currentVersion(), build: AppInfoTracker.currentBuild())
        
        isFirstLaunchOfToday = AppInfoTracker.numbersOfStartupsForToday() == 1
    }
    
    fileprivate func updateFirstLaunchForVersion() {
        let currentVersion = AppInfoTracker.currentVersion()
        let currentBuild = AppInfoTracker.currentBuild()

        let latestVersion: String = versionHistory.last ?? ""
        
        if currentVersion != latestVersion {
            versionHistory.append(currentVersion)
            UserDefaults.standard.set(versionHistory, forKey: TrackerKey.versionHistory.rawValue)
            UserDefaults.standard.synchronize()
        }
        
        if var buildMap = versionMap[currentVersion] {
            var numbersOfStartupsForPreBuild = 1
            if let count = buildMap[currentBuild] {
                numbersOfStartupsForPreBuild = count + 1
            }
            buildMap[currentBuild] = numbersOfStartupsForPreBuild
            versionMap[currentVersion] = buildMap
        } else {
            let buildMap = [currentBuild: 1]
            versionMap[currentVersion] = buildMap
        }
        
        UserDefaults.standard.set(versionMap, forKey: TrackerKey.versionMap.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func updateFirstLaunchForToday() {
        if let num = dayLaunchMap[todayId] {
            dayLaunchMap[todayId] = num + 1
        } else {
            dayLaunchMap[todayId] = 1
        }
        
        let keys = dayLaunchMap.keys.sorted { (s1, s2) -> Bool in
            return s1.compare(s2) == ComparisonResult.orderedDescending
        }
        if keys.count > 7 {
            dayLaunchMap.removeValue(forKey: keys[7])
        }

        UserDefaults.standard.set(dayLaunchMap, forKey: TrackerKey.dayLaunch.rawValue)
        UserDefaults.standard.synchronize()
    }
}

