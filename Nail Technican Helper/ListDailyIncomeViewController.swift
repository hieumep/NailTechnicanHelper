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

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


@available(iOS 10.0, *)

class ListDailyIncomeViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    var incomes : [DailyIncome]? = [DailyIncome]()
    var sumIncome = 0
    var sumRealIncome = 0
    var sumCardTip = 0
    var sumCashTip = 0
    var pickFromDate : Date? = nil
    var pickToDate : Date? = nil
    let textUltilities = TextUtilities()
    
    var startDate = DateConvenient(date: Date(), addDay: -7)
    var endDate = DateConvenient(date: Date())
    let fetchRequest: NSFetchRequest<DailyIncome>? = DailyIncome.fetchRequest() as? NSFetchRequest<DailyIncome>
    
    @IBOutlet weak var sumIncomeLabel: UILabel!
    @IBOutlet weak var distanceDate: UILabel!
    @IBOutlet weak var sumRealIncomeLabel: UILabel!
    @IBOutlet weak var sumCardTipLabel: UILabel!
    @IBOutlet weak var sumCashTipLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        sum(incomes)
    //    setDateAndLoadData()
    }
    
    func setDateAndLoadData() {
        if let _ = pickFromDate {
            startDate = DateConvenient(date: pickFromDate!)
            endDate = DateConvenient(date:pickToDate!)
        }else {
            startDate = DateConvenient(date: Foundation.Date(), addDay: -7)
            endDate = DateConvenient(date: Foundation.Date())
        }
       
        distanceDate.text = "\(startDate.getStartDateString()) -> \(endDate.getEndDateString())"
        do {
            fetchRequest?.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", self.startDate.getStartDate() as CVarArg, self.endDate.getEndDate() as CVarArg)
            try fetchResultController.performFetch()
        }catch{
            print(error)
        }
    //    fetchResultController.delegate = self
        incomes = fetchResultController.fetchedObjects
        sum(incomes)
        tableView.reloadData()
        
    }
    
    func loadAds(){
        appDelegate.iAdBannerAdView.center = CGPoint(
            x: view.frame.midX,
            y:  view.frame.height - appDelegate.iAdBannerAdView.frame.height / 2)
        if !appDelegate.iAdBannerAdView.isBannerLoaded {
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
          //  fetchRequest = NSFetchRequest(entityName: "DailyIncome")
          //  fetchRequest!.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", self.startDate.getStartDate(), self.endDate.getEndDate())
            fetchRequest?.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
         /*   try fetchResultController.performFetch()
        }catch{
            print(error)
        }
 
        fetchResultController.delegate = self
        sum(incomes)
 */
        fetchResultController.delegate = self
        setDateAndLoadData()
        NotificationCenter.default.addObserver(self, selector:#selector(setDateAndLoadData), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func sum(_ incomes : [DailyIncome]?){
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
        sumIncomeLabel.text = textUltilities.stringToNumberNoZero(String(sumIncome))
        sumRealIncomeLabel.text = textUltilities.stringToNumberNoZero(String(sumRealIncome))
        sumCardTipLabel.text = textUltilities.stringToNumberNoZero(String(sumCardTip))
        sumCashTipLabel.text = textUltilities.stringToNumberNoZero(String(sumCashTip))
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
       CoreDataStackManager.sharedInstance().managerObjectContext
    }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    lazy var fetchResultController : NSFetchedResultsController<DailyIncome>  = {
        let fetchRequest: NSFetchRequest<DailyIncome> = DailyIncome.fetchRequest() as! NSFetchRequest<DailyIncome>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let fetchResultController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    
        return fetchResultController
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = self.fetchResultController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let income = self.fetchResultController.object(at: indexPath) 
        let cell = tableView.dequeueReusableCell(withIdentifier: "listIncomeCell") as! ListDailyIncomeCell
        let realIncome = (Int(income.income) *  Int((income.shops?.percent)!) / 100)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        cell.dateLabel.text = dateFormatter.string(from: (income.date as Date))
        cell.incomeLabel.text = textUltilities.stringToNumberNoZero(String(describing: income.income))
        cell.realIncomeLabel.text = textUltilities.stringToNumberNoZero(String(realIncome))
        cell.cardTipsLabel.text = textUltilities.stringToNumberNoZero(String(describing: income.cardTip))
        cell.cashTipsLabel.text = textUltilities.stringToNumberNoZero(String(describing: income.cashTip))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dailyIncome = self.fetchResultController.object(at: indexPath)
        let dailyIncomeVC = storyboard?.instantiateViewController(withIdentifier: "dailyIncomeVC") as! DailyIncomeViewController
        dailyIncomeVC.dailyIncome = dailyIncome
        dailyIncomeVC.fetchRequest = self.fetchRequest!
        dailyIncomeVC.indexPath = indexPath
        self.present(dailyIncomeVC, animated: true, completion: nil)
    }
    
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let income = self.fetchResultController.object(at: indexPath) 
        switch (editingStyle) {
        case .delete :
            sumIncome = sumIncome - Int(income.income)
            sumRealIncome = sumRealIncome - (Int(income.income) * Int((income.shops?.percent)!) / 100)
            sumCardTip = sumCardTip - Int(income.cardTip)
            sumCashTip = sumCashTip - Int(income.cashTip)
            showSum()
            sharedContext.delete(income)
            self.saveContext()
        default:
            return
        }
    }    
}

