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
    var incomes : [DailyIncome]? = [DailyIncome]()
    var sumIncome = 0
    var sumRealIncome = 0
    var sumCardTip = 0
    var sumCashTip = 0
    var pickFromDate : NSDate? = nil
    var pickToDate : NSDate? = nil
    let textUltilities = TextUtilities()
    
    var startDate = Date(date: NSDate(), addDay: -7)
    var endDate = Date(date: NSDate())
    var fetchRequest : NSFetchRequest? = nil
    
    @IBOutlet weak var sumIncomeLabel: UILabel!
    @IBOutlet weak var distanceDate: UILabel!
    @IBOutlet weak var sumRealIncomeLabel: UILabel!
    @IBOutlet weak var sumCardTipLabel: UILabel!
    @IBOutlet weak var sumCashTipLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.iAdBannerAdView.center = CGPoint(
            x:  view.frame.midX,
            y:  appDelegate.iAdBannerAdView.frame.height / 2)
        view.addSubview(appDelegate.iAdBannerAdView)
        
        
        appDelegate.adMobBannerAdView.rootViewController = self
        appDelegate.adMobBannerAdView.center = CGPoint(
            x: view.frame.midX,
            y: appDelegate.adMobBannerAdView.frame.height / 2)
        view.addSubview(appDelegate.adMobBannerAdView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        sum(incomes)
    //    setDateAndLoadData()
    }
    
    func setDateAndLoadData() {
        if let _ = pickFromDate {
            startDate = Date(date: pickFromDate!)
            endDate = Date(date:pickToDate!)
        }else {
            startDate = Date(date: NSDate(), addDay: -7)
            endDate = Date(date: NSDate())
        }
       
        distanceDate.text = "\(startDate.getStartDateString()) -> \(endDate.getEndDateString())"
        do {
            fetchRequest!.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", self.startDate.getStartDate(), self.endDate.getEndDate())
            try fetchResultController.performFetch()
        }catch{
            print(error)
        }
    //    fetchResultController.delegate = self
        incomes = fetchResultController.fetchedObjects as? [DailyIncome]
        sum(incomes)
        tableView.reloadData()
        
    }
    
    func loadAds(){
        appDelegate.iAdBannerAdView.center = CGPoint(
            x: view.frame.midX,
            y:  view.frame.height - appDelegate.iAdBannerAdView.frame.height / 2)
        if !appDelegate.iAdBannerAdView.bannerLoaded {
            view.addSubview(appDelegate.iAdBannerAdView)
        }
        
        appDelegate.adMobBannerAdView.rootViewController = self
        appDelegate.adMobBannerAdView.center = CGPoint(
            x: view.frame.midX,
            y: view.frame.height - appDelegate.adMobBannerAdView.frame.height / 2)
        view.addSubview(appDelegate.adMobBannerAdView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
     /*   if let _ = pickFromDate {
            startDate = Date(date: pickFromDate!)
            endDate = Date(date:pickToDate!)
        }
        do {
 */
            fetchRequest = NSFetchRequest(entityName: "DailyIncome")
          //  fetchRequest!.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", self.startDate.getStartDate(), self.endDate.getEndDate())
            fetchRequest!.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
         /*   try fetchResultController.performFetch()
        }catch{
            print(error)
        }
 
        fetchResultController.delegate = self
        sum(incomes)
 */
        fetchResultController.delegate = self
        setDateAndLoadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(setDateAndLoadData), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func sum(incomes : [DailyIncome]?){
        sumIncome = 0
        sumRealIncome = 0
        sumCardTip = 0
        sumCashTip = 0
        if incomes?.count >= 0 {
            for i in 0..<incomes!.count {
                sumIncome += incomes![i].income as Int
                sumRealIncome += (Int(incomes![i].income) * Int((incomes![i].shops?.percent)!) / 100)
                sumCardTip += incomes![i].cardTip as Int
                sumCashTip += incomes![i].cashTip as Int
            }
        }
        showSum()
    }
    
    func showSum(){
        sumIncomeLabel.text = textUltilities.stringToNumber(String(sumIncome))
        sumRealIncomeLabel.text = textUltilities.stringToNumber(String(sumRealIncome))
        sumCardTipLabel.text = textUltilities.stringToNumber(String(sumCardTip))
        sumCashTipLabel.text = textUltilities.stringToNumber(String(sumCashTip))
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
       CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    lazy var fetchResultController : NSFetchedResultsController = {
       
        let fetchResultController =  NSFetchedResultsController(fetchRequest: self.fetchRequest!, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    
        return fetchResultController
    }()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = self.fetchResultController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let income = self.fetchResultController.objectAtIndexPath(indexPath) as! DailyIncome
        let cell = tableView.dequeueReusableCellWithIdentifier("listIncomeCell") as! ListDailyIncomeCell
        let realIncome = (Int(income.income) *  Int((income.shops?.percent)!) / 100)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        cell.dateLabel.text = dateFormatter.stringFromDate(income.date)
        cell.incomeLabel.text = textUltilities.stringToNumber(String(income.income))
        cell.realIncomeLabel.text = textUltilities.stringToNumber(String(realIncome))
        cell.cardTipsLabel.text = textUltilities.stringToNumber(String(income.cardTip))
        cell.cashTipsLabel.text = textUltilities.stringToNumber(String(income.cashTip))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dailyIncome = self.fetchResultController.objectAtIndexPath(indexPath) as! DailyIncome
        let dailyIncomeVC = storyboard?.instantiateViewControllerWithIdentifier("dailyIncomeVC") as! DailyIncomeViewController
        dailyIncomeVC.dailyIncome = dailyIncome
        dailyIncomeVC.fetchRequest = self.fetchRequest
        dailyIncomeVC.indexPath = indexPath
        self.presentViewController(dailyIncomeVC, animated: true, completion: nil)
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
            sumIncome = sumIncome - Int(income.income)
            sumRealIncome = sumRealIncome - (Int(income.income) * Int((income.shops?.percent)!) / 100)
            sumCardTip = sumCardTip - Int(income.cardTip)
            sumCashTip = sumCashTip - Int(income.cashTip)
            showSum()
            sharedContext.deleteObject(income)
            self.saveContext()
        default:
            return
        }
    }    
}

