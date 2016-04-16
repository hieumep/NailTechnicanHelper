//
//  ListDailyIncomeViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/13/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListDailyIncomeViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchResultController.performFetch()
        }catch{
            print(error)
        }
        fetchResultController.delegate = self
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
       CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    lazy var fetchResultController : NSFetchedResultsController = {
        let startDate = Date(date: NSDate(), addDay: -7)
        let endDate = Date(date: NSDate())
        let fetchRequest = NSFetchRequest(entityName: "DailyIncome")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate.getStartDate(), endDate.getEndDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let fetchResultController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = self.fetchResultController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let income = self.fetchResultController.objectAtIndexPath(indexPath) as! DailyIncome
        let cell = tableView.dequeueReusableCellWithIdentifier("listIncomeCell") as! ListDailyIncomeCell
        let realIncome = Double(Int(income.income) *  Int((income.shops?.percent)!) / 100)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        cell.dateLabel.text = dateFormatter.stringFromDate(income.date)
        cell.incomeLabel.text = "\(income.income)"
        cell.realIncomeLabel.text = "\(realIncome)"
        cell.cardTipsLabel.text = "\(income.cardTip)"
        cell.cashTipsLabel.text = "\(income.cashTip)"
        return cell
    }
    
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let income = self.fetchResultController.objectAtIndexPath(indexPath) as! DailyIncome
        switch (editingStyle) {
        case .Delete :
            sharedContext.deleteObject(income)
            self.saveContext()
        default:
            return
        }
    }    
}

