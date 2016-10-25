//
//  NailShopTableViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/6/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import UIKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


@available(iOS 10.0, *)
class NailShopTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    var selectedRow : Int? = nil
    let fetchRequest: NSFetchRequest<NailShop> = NailShop.fetchRequest() as! NSFetchRequest<NailShop>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultController.performFetch()
        }catch{
            print(error)
        }
        fetchedResultController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorColor = UIColor.brown
        tableView.reloadData()
    }
    
    lazy var shareContext : NSManagedObjectContext = {
       return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    lazy var fetchedResultController : NSFetchedResultsController<NailShop> = {
        let fetchRequest: NSFetchRequest<NailShop> = NailShop.fetchRequest() as! NSFetchRequest<NailShop>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nailShop", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.shareContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch  type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        default :
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = self.fetchedResultController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shop = self.fetchedResultController.object(at: indexPath)
        let cellIdentifier = "nailShopCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NailShopCellControler
        cell.nailShopLabel.text = shop.nailShop
        cell.percentLabel.text = "\(shop.percent)"
        cell.phoneNumberLabel.text = shop.phoneNumber
        
        if shop.selected {
            cell.selectButton.isHidden = true
            cell.selectedLabel.isHidden = false
            self.selectedRow = (indexPath as NSIndexPath).row
        } else {
            cell.selectedLabel.isHidden = true
            cell.selectButton.isHidden = false
            cell.selectButton.tag = (indexPath as NSIndexPath).row
            cell.selectButton.addTarget(self, action: #selector(NailShopTableViewController.selectShop), for: .touchUpInside)
        }
        return cell
    }
    
    @IBAction func selectShop(_ sender : UIButton){
        let selectRow = sender.tag
       // let fetchRequest = NSFetchRequest(entityName: "NailShop")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nailShop", ascending: true)]
        do {
            let results = try self.shareContext.fetch(fetchRequest)
            results[selectRow].selected = true
            if let _ = selectedRow {
                results[selectedRow!].selected = false
            }
            CoreDataStackManager.sharedInstance().saveContext()
            self.tableView.reloadData()
        }catch{
            print(error)
        }
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let shop = self.fetchedResultController.object(at: indexPath)
        switch (editingStyle) {
        case .delete :
            if shop.dailyIncomes?.count <= 0 && shop.eachCustomerIncomes?.count <= 0 {
                shareContext.delete(shop)
                CoreDataStackManager.sharedInstance().saveContext()
            }else{
                let alert = UIAlertController(title: "Error", message: "It have data, you can delete it", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Okie", style: .cancel, handler: nil)
                alert.addAction(cancelButton)
                self.present(alert, animated: true, completion: nil)
            }
        default:
            return
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shop = self.fetchedResultController.object(at: indexPath)
        let nailShopViewController = self.storyboard!.instantiateViewController(withIdentifier: "NailShopViewController")as! NailShopViewController
        nailShopViewController.shop = shop
        nailShopViewController.indexPath = indexPath
        self.navigationController?.pushViewController(nailShopViewController, animated: true)        
    }
    
    
    @IBAction func backAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
