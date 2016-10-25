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
    var pickFromDate : Date? = nil
    var pickToDate : Date? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickFromDate = fromDatePicker.date
        pickToDate = toDatePicker.date
    }
    
    override func viewDidLoad() {
        loadInterstitial()
    }
    
    @IBAction func fromDatePick(_ sender: AnyObject) {
        pickFromDate = fromDatePicker.date
        
    }
    
    @IBAction func toDatePick(_ sender: AnyObject) {
        pickToDate = toDatePicker.date
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }else{
            self.performSegue(withIdentifier: "showListSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showListSegue" {
            if #available(iOS 10.0, *) {
                let ListDailyIncomeVC = segue.destination as! ListDailyIncomeViewController
                ListDailyIncomeVC.pickFromDate = pickFromDate
                ListDailyIncomeVC.pickToDate = pickToDate
            } else {
                // Fallback on earlier versions
            }
            /*
            ListDailyIncomeVC.pickFromDate = pickFromDate
            ListDailyIncomeVC.pickToDate = pickToDate
 */
        }
    }
    
    func loadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/2934735716")
        interstitial.delegate = self
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9a" ]
        interstitial.load(request)

    }
    // MARK: - GADInterstitialDelegate
    
    func interstitialDidFailToReceiveAdWithError(_ interstitial: GADInterstitial,
                                                 error: GADRequestError) {
        print("\(#function): \(error.localizedDescription)")
    }
    
    func interstitialDidDismissScreen(_ interstitial: GADInterstitial) {
       self.performSegue(withIdentifier: "showListSegue", sender: self)
    }

    
}
