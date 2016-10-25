//
//  DailyIncome.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/5/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import CoreData
import UIKit
import Foundation

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
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dailyIncomeDict : [String : AnyObject], context : NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: "DailyIncome", in: context)!
        super.init(entity: entity, insertInto: context)
        date = dailyIncomeDict[keys.date] as! NSDate
        income = dailyIncomeDict[keys.income] as! NSNumber
        cardTip = dailyIncomeDict[keys.cardTip] as! NSNumber
        cashTip = dailyIncomeDict[keys.cashTip] as! NSNumber       
        photo = dailyIncomeDict[keys.photo] as? String
    }
}
