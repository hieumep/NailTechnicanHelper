//
//  AppDelegate.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 3/31/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData
import iAd
import GoogleMobileAds
import Firebase

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,ADBannerViewDelegate, GADBannerViewDelegate {

    var window: UIWindow?    
    var iAdBannerAdView: ADBannerView! = ADBannerView()
    var adMobBannerAdView: GADBannerView! = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //CoreDataStackManager.sharedInstance().mirgationData([NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        // Override point for customization after application launch.
        iAdBannerAdView.delegate = self
        iAdBannerAdView.isHidden = true
        adMobBannerAdView.delegate = nil // attension!
        adMobBannerAdView.isHidden = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        iAdBannerAdView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        adMobBannerAdView.isHidden = true
    }    
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        iAdBannerAdView.isHidden = true
        // Try Admob here
       // FIRApp.configure()
        adMobBannerAdView.delegate = self
        adMobBannerAdView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]; // Simulator
        adMobBannerAdView.load(GADRequest())
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        adMobBannerAdView.isHidden = false
    }    
}

