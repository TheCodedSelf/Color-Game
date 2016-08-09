//
//  AppManager.swift
//  ColorGame
//
//  Created by Keegan on 1/20/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit
var __sharedInstance: AppManager?

@objc class AppManager: NSObject {
    
class func sharedInstance() -> AppManager
    {
    if __sharedInstance == nil
        {
        __sharedInstance = AppManager()
        }
    return __sharedInstance!
    }
    
let pointsLimit = 100000
var oldTintColor: UIColor!

var currentPoints: Int
    {
    get
        {
        let x = NSUserDefaults.standardUserDefaults().objectForKey("POINTS") as? Int ?? 0
        return x
        }
    set
        {
        NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "POINTS")
        if newValue  >= pointsLimit
            {
            handlePointsLimitReached()
            }
        NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var pointsMultiplierRounds: Int
        {
        get
        {
            let x = NSUserDefaults.standardUserDefaults().objectForKey("MULTIPLIER_ROUNDS") as? Int ?? 0
            return x
        }
        set
        {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "MULTIPLIER_ROUNDS")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
func handlePointsLimitReached()
    {
    currentPoints = 0
    }
}
