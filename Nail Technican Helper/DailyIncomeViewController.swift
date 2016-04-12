//
//  DailyIncomeViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/10/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class DailyIncomeViewController : UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var pickShopLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainView: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var percentLabel: UILabel!
    
    
    @IBOutlet weak var incomeText: UITextField!
    
    @IBOutlet weak var cardTipsText: UITextField!
    
   
    @IBOutlet weak var cashTipsText: UITextField!
    @IBOutlet weak var realIncomeLabel: UILabel!
    
    var flagDate  = true
    
    var shop :NailShop?
    override func viewWillAppear(animated: Bool) {
        getCurrentShop()
        let date = formatDate(NSDate())
        dateButton.setTitle("\(date)", forState: .Normal)
        incomeText.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pickShopLabel.text = " You don't set up Nail Shop yet, please tap EDIT to pick your current Nail Shop"
      
    }
    
    @IBAction func dateFromDatePicker(sender: AnyObject) {
        let date = formatDate(datePicker.date)
        dateButton.setTitle("\(date)", forState: .Normal)
    }
    
    @IBAction func pickDate(sender: AnyObject) {
        flagDate = !flagDate
        datePicker.hidden = flagDate
        dateLabel.hidden = !flagDate
    }
    
    func formatDate(date: NSDate) -> String {
        let dateFormater = NSDateFormatter()
        dateFormater.locale = NSLocale.currentLocale()
        dateFormater.dateStyle = .FullStyle
        let dateString = dateFormater.stringFromDate(date)
        return dateString
    }
    func getCurrentShop (){
        let fetchRequest = NSFetchRequest(entityName: "NailShop")
        fetchRequest.predicate = NSPredicate(format: "selected==true")
        do {
           let shops = try sharedContext.executeFetchRequest(fetchRequest) as? [NailShop]
        if shops?.count >= 1  {
            shopLabel.text = shops![0].nailShop
            percentLabel.text = "\(shops![0].percent)"
            shop = shops![0]
            mainView.hidden = false
            pickShopLabel.hidden = true
        }else {
            mainView.hidden = true
            pickShopLabel.hidden = false
            }
        }catch{
            print(error)
            abort()
        }
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !textField.text!.isEmpty {
            let percent = shop?.percent as! Int
            let realIncomeLabel = Double(Int(textField.text!)! * percent/100)
            self.realIncomeLabel.text = "\(realIncomeLabel)"
        } else {
            textField.text = "0"
            self.realIncomeLabel.text = "0"
        }
    }
}
