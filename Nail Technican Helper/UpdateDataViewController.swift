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
    
    @IBAction func incomeButton(_ sender: AnyObject) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyIncome")
        do{
            let dailyIncomes = try shareContext.fetch(fetchRequest) as! [DailyIncome]
            for income in dailyIncomes {
                let incomes : Int  = Int(income.income) * 100
             //   print(incomes)
                income.income = NSNumber(value: incomes)
                income.cardTip = NSNumber(value: Int(Int(income.cardTip) * 100))
                income.cashTip = NSNumber(value: Int(Int(income.cashTip) * 100))
            }
        saveContext()
        }catch {
            print(error)
        }
    }
    
    @IBAction func cashTipsButton(_ sender: AnyObject) {
    }
    
    @IBAction func cardTipsButton(_ sender: AnyObject) {
    }
}
