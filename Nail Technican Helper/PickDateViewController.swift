//
//  PickDateViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 5/2/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class PickDateViewController : UIViewController{
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    
    @IBOutlet weak var toDatePicker: UIDatePicker!
    var pickFromDate : NSDate? = nil
    var pickToDate : NSDate? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickFromDate = fromDatePicker.date
        pickToDate = toDatePicker.date
    }
    
    @IBAction func fromDatePick(sender: AnyObject) {
        pickFromDate = fromDatePicker.date
        
    }
    
    @IBAction func toDatePick(sender: AnyObject) {
        pickToDate = toDatePicker.date
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "showListSegue" {
            let ListDailyIncomeVC = segue.destinationViewController as! ListDailyIncomeViewController
            ListDailyIncomeVC.pickFromDate = pickFromDate
            ListDailyIncomeVC.pickToDate = pickToDate
        }
        
    }
    
}