//
//  PickDateViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 5/2/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import GoogleMobileAds
import UIKit

class PickDateViewController : UIViewController, GADInterstitialDelegate{
    
    var interstitial: GADInterstitial!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    
    @IBOutlet weak var toDatePicker: UIDatePicker!
    var pickFromDate : NSDate? = nil
    var pickToDate : NSDate? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickFromDate = fromDatePicker.date
        pickToDate = toDatePicker.date
    }
    
    override func viewDidLoad() {
        loadInterstitial()
    }
    
    @IBAction func fromDatePick(sender: AnyObject) {
        pickFromDate = fromDatePicker.date
        
    }
    
    @IBAction func toDatePick(sender: AnyObject) {
        pickToDate = toDatePicker.date
    }
    
    @IBAction func submit(sender: AnyObject) {
        if interstitial.isReady {
            interstitial.presentFromRootViewController(self)
        }else{
            self.performSegueWithIdentifier("showListSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "showListSegue" {
            let ListDailyIncomeVC = segue.destinationViewController as! ListDailyIncomeViewController
            ListDailyIncomeVC.pickFromDate = pickFromDate
            ListDailyIncomeVC.pickToDate = pickToDate
        }
    }
    
    func loadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADInterstitial automatically returns test ads when running on a
        // simulator.
        interstitial.loadRequest(GADRequest())
    }
    // MARK: - GADInterstitialDelegate
    
    func interstitialDidFailToReceiveAdWithError(interstitial: GADInterstitial,
                                                 error: GADRequestError) {
        print("\(#function): \(error.localizedDescription)")
    }
    
    func interstitialDidDismissScreen(interstitial: GADInterstitial) {
       self.performSegueWithIdentifier("showListSegue", sender: self)
    }

    
}