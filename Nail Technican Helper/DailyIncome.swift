//
//  DailyIncome.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/5/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import CoreData
import UIKit

class DailyIncome : NSManagedObject {
    struct keys {
        static let date = "date"
        static let income = "income"
        static let cardTip = "card_tip"
        static let cashTip = "cash_tip"
        static let photo = "photo_path'"
    }
    
    @NSManaged var date : NSDate
    @NSManaged var income : NSNumber
    @NSManaged var cardTip : NSNumber
    @NSManaged var cashTip : NSNumber
    @NSManaged var photo : String?
    @NSManaged var shops : NailShop?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dailyIncomeDict : [String : AnyObject], context : NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("DailyIncome", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        date = dailyIncomeDict[keys.date] as! NSDate
        income = dailyIncomeDict[keys.income] as! Int
        cardTip = dailyIncomeDict[keys.cardTip] as! Int
        cashTip = dailyIncomeDict[keys.cashTip] as! Int
        photo = dailyIncomeDict[keys.photo] as? String
    }
}
