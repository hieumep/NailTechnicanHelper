//
//  UpdateDataViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 6/28/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UpdateDataViewController : UIViewController{
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var cardTipsLabel: UILabel!
    @IBOutlet weak var cashTipsLabel: UILabel!
    
    lazy var shareContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    @IBAction func incomeButton(sender: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "DailyIncome")
        do {
            let dailyIncomes = try shareContext.executeFetchRequest(fetchRequest) as! [DailyIncome]
            for income in dailyIncomes {
                let incomes : Int  = Int(income.income) * 100
                print(incomes)
                income.income = incomes
                income.cardTip = Int(Int(income.cardTip) * 100)
                income.cashTip = Int(Int(income.cashTip) * 100)
            }
      //  saveContext()
        }catch {
            print(error)
        }
    }
    
    @IBAction func cashTipsButton(sender: AnyObject) {
    }
    
    @IBAction func cardTipsButton(sender: AnyObject) {
    }
}
