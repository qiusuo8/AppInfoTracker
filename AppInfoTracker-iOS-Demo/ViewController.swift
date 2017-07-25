//
//  ViewController.swift
//  AppInfoTracker-iOS-Demo
//
//  Created by zhaozh on 2017/7/21.
//  Copyright © 2017年 qiusuo8. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        print("-------------- version launch history --------------")
        print(AppInfoTracker.shared.versionHistory)
        
        print("-------------- version info --------------")
        print(AppInfoTracker.previousVersion() ?? "")

        print(AppInfoTracker.currentVersion())
        print(AppInfoTracker.currentBuild())

        print(AppInfoTracker.shared.isFirstLaunchForCurrentVersion)
        print(AppInfoTracker.shared.isFirstLaunchForCurrentVersionAndBuild)

        print("-------------- current version times of start app --------------")
        print(AppInfoTracker.numbersOfStartupsForVersion(AppInfoTracker.currentVersion()))
        
        print("-------------- current version and build times of start app --------------")
        print(AppInfoTracker.numbersOfStartupsForVersion(AppInfoTracker.currentVersion(), build: AppInfoTracker.currentBuild()))
        
        print("-------------- for certain version or build --------------")
        print(AppInfoTracker.isFirstLaunchForVersion("1.2"))
        print(AppInfoTracker.isFirstLaunchForVersion("1.2", build: "2"))
        
        
        _ = AppInfoTracker.isFirstLaunchForVersion("1.1") {
            print("First launch for version 1.1")
        }
        
        _ = AppInfoTracker.isFirstLaunchForVersion("1.1", build: "2", firstLaunchCompletion: {
            print("First launch for version 1.1 build 2")
        })
        
        print("-------------- launch times for day --------------")
        print(AppInfoTracker.shared.isFirstLaunchOfToday)
        print(AppInfoTracker.numbersOfStartupsForToday())
        _ = AppInfoTracker.isFirstLaunchForToday {
            print("First launch for today")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

