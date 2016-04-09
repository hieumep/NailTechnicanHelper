//
//  NailShopViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/3/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NailShopViewController : UIViewController {
    
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var commissionTextField: UITextField!
    
    
    @IBOutlet weak var nailShopTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()
    
    var shop : NailShop?
    var indexPath : NSIndexPath?
    
    @IBAction func cancelButton(sender: AnyObject) {
        if let _ = shop {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else {
            commissionTextField.text = ""
            nailShopTextField.text = ""
            phoneNumberTextField.text = ""
            addressTextView.text = ""
        }
    }
    
    override func viewDidLoad() {
        addressTextView.layer.borderWidth = 0.5
        commissionTextField.delegate = textFieldDelegate
        nailShopTextField.delegate = textFieldDelegate
        phoneNumberTextField.delegate = textFieldDelegate
        if let shopInfo = shop {
            getShopEditInfo(shopInfo)
        }
    }
    
    @IBAction func SaveShop(sender: AnyObject) {
        if actionButton.titleLabel?.text == "Save" {
            if getShopDict() {
                let shop : [String:AnyObject] = [
                    NailShop.keys.percent : commissionTextField.text!,
                    NailShop.keys.nailShop : nailShopTextField.text!,
                    NailShop.keys.phoneNumber : phoneNumberTextField.text! ?? "",
                    NailShop.keys.address : addressTextView.text! ?? ""
                ]
                let _ = NailShop(nailShops: shop, context: self.sharedContext)
                saveContext()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }else{
            let fetchRequest = NSFetchRequest(entityName: "NailShop")
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "nailShop", ascending: true)]
            do {
                var fetchResults = try sharedContext.executeFetchRequest(fetchRequest) as! [NailShop]
                let shop = fetchResults[indexPath!.row]
                if getShopDict(){
                    shop.percent = Int(commissionTextField.text!)!
                    shop.nailShop = nailShopTextField.text!
                    shop.phoneNumber = phoneNumberTextField.text! ?? ""
                    shop.address = addressTextView.text! ?? ""
                    saveContext()
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            }catch{
                print(error)
            }
            
        }
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
       return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func getShopEditInfo(shopInfo : NailShop!) {
        nailShopTextField.text  = shopInfo.nailShop
        commissionTextField.text = "\(shopInfo.percent)"
        phoneNumberTextField.text = shopInfo.phoneNumber
        addressTextView.text = shopInfo.address
        actionButton.setTitle("Edit", forState: .Normal)
        self.title = "Edit Nail Shop"
        
    }
    
    func getShopDict() -> Bool {
        if !commissionTextField.text!.isEmpty && !nailShopTextField.text!.isEmpty {
            return true
        }else {
         //   let alert = UIAlertView(title: "Error", message: "Commission and Nail Shop can be empty", delegate: nil, cancelButtonTitle: "okie")
            let alert = UIAlertController(title: "Error", message: "Commission and Nail Shop can be empty", preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "Okie", style: .Cancel, handler: nil)
            alert.addAction(cancelButton)
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
    }
}
