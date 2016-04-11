//
//  DailyIncomeViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/10/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class DailyIncomeViewController : UIViewController {
    
    @IBOutlet weak var pickShopLabel: UILabel!
    @IBOutlet weak var shopLabel: UILabel!
    
    @IBOutlet weak var percentLabel: UILabel!
    var shops :[NailShop]? = [NailShop]()
    override func viewWillAppear(animated: Bool) {
        getCurrentShop()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pickShopLabel.text = " You don't set up Nail Shop yet, please tap EDIT to pick your current Nail Shop"
      //  getCurrentShop()
    }
    
    func getCurrentShop (){
        let fetchRequest = NSFetchRequest(entityName: "NailShop")
        fetchRequest.predicate = NSPredicate(format: "selected==true")
        do {
            shops = try sharedContext.executeFetchRequest(fetchRequest) as? [NailShop]
        if let shops = shops {
            shopLabel.text = shops[0].nailShop
            percentLabel.text = "\(shops[0].percent)"
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
}
