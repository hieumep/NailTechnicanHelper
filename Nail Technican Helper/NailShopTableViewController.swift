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

class NailShopTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultController.performFetch()
        }catch{
            print(error)
        }
        fetchedResultController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorColor = UIColor.brownColor()
        tableView.reloadData()
    }
    
    lazy var shareContext : NSManagedObjectContext = {
       return CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    lazy var fetchedResultController : NSFetchedResultsController = {
        let requestFetched = NSFetchRequest(entityName: "NailShop")
        requestFetched.sortDescriptors = [NSSortDescriptor(key: "nailShop", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: requestFetched, managedObjectContext: self.shareContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch  type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default :
            return
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = self.fetchedResultController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let shop = self.fetchedResultController.objectAtIndexPath(indexPath) as! NailShop
        let cellIdentifier = "nailShopCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! NailShopCellControler
        cell.nailShopLabel.text = shop.nailShop
        cell.percentLabel.text = "\(shop.percent)"
        cell.phoneNumberLabel.text = shop.phoneNumber
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let shop = self.fetchedResultController.objectAtIndexPath(indexPath) as! NailShop
        switch (editingStyle) {
        case .Delete :
            if shop.dailyIncomes?.count <= 0 && shop.eachCustomerIncomes?.count <= 0 {
                shareContext.deleteObject(shop)
                CoreDataStackManager.sharedInstance().saveContext()
            }
        default:
            return
        }
        
    }
    
}
