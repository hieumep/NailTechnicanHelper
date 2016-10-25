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
  
    @IBOutlet weak var addressTextView: UITextField!
    
    @IBOutlet weak var commissionTextField: UITextField!
    
    
    @IBOutlet weak var nailShopTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()
    
    var shop : NailShop?
    var indexPath : IndexPath?
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        if let _ = shop {
            _ = navigationController?.popToRootViewController(animated: true)
        }else {
            commissionTextField.text = ""
            nailShopTextField.text = ""
            phoneNumberTextField.text = ""
            addressTextView.text = ""
        }
    }
    
    override func viewDidLoad() {
        addressTextView.layer.borderWidth = 0.5        
        addressTextView.layer.cornerRadius = 8.0
       // commissionTextField.delegate = textFieldDelegate
      //  nailShopTextField.delegate = textFieldDelegate
      //  phoneNumberTextField.delegate = textFieldDelegate
        if let shopInfo = shop {
            getShopEditInfo(shopInfo)
        }
        
    }
    
    @IBAction func SaveShop(_ sender: AnyObject) {
        if actionButton.titleLabel?.text == "Save" {
            if getShopDict() {
                let shop : [String:AnyObject] = [
                    NailShop.keys.percent : NSNumber(value: Int(commissionTextField.text!)!),
                    NailShop.keys.nailShop : nailShopTextField.text! as AnyObject,
                    NailShop.keys.phoneNumber : phoneNumberTextField.text! as AnyObject? ?? "" as String as AnyObject,
                    NailShop.keys.address : addressTextView.text! as AnyObject? ?? "" as AnyObject
                ]
                let _ = NailShop(nailShops: shop, context: self.sharedContext)
                saveContext()
                _ = navigationController?.popToRootViewController(animated: true)
            }
        }else{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NailShop")
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "nailShop", ascending: true)]
            do {
                var fetchResults = try sharedContext.fetch(fetchRequest) as! [NailShop]
                let shop = fetchResults[(indexPath! as NSIndexPath).row]
                if getShopDict(){
                    shop.percent = NSNumber(value: Int(commissionTextField.text!)!)
                    shop.nailShop = nailShopTextField.text!
                    shop.phoneNumber = phoneNumberTextField.text!
                    shop.address = addressTextView.text!
                    saveContext()
                    _ = navigationController?.popViewController(animated: true)
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
    
    func getShopEditInfo(_ shopInfo : NailShop!) {
        nailShopTextField.text  = shopInfo.nailShop
        commissionTextField.text = "\(shopInfo.percent)"
        phoneNumberTextField.text = shopInfo.phoneNumber
        addressTextView.text = shopInfo.address
        actionButton.setTitle("Edit", for: UIControlState())
        self.title = "Edit Nail Shop"
        
    }
    
    func getShopDict() -> Bool {
        if !commissionTextField.text!.isEmpty && !nailShopTextField.text!.isEmpty {
            return true
        }else {
         //   let alert = UIAlertView(title: "Error", message: "Commission and Nail Shop can be empty", delegate: nil, cancelButtonTitle: "okie")
            let alert = UIAlertController(title: "Error", message: "Commission and Nail Shop can be empty", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Okie", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
}
