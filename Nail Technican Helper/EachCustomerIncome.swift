//
//  EachCustomerIncome.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/5/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import CoreData

class EachCustomerIncome : NSManagedObject{
    struct keys{
        static let date = "date"
        static let income = "income"
        static let cardTip = "card_tip"
        static let cashTip = "cash_tip"
    }
    @NSManaged var date : Foundation.Date
    @NSManaged var income : Int
    @NSManaged var cardTip : Int
    @NSManaged var cashTip : Int
    @NSManaged var shop : NailShop?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(eachCustomerIncomeDict : [String : AnyObject], context : NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: "EachCustomerIncome", in: context)!
        super.init(entity: entity, insertInto: context)
        date = eachCustomerIncomeDict[keys.date] as! Foundation.Date
        income = eachCustomerIncomeDict[keys.income] as! Int
        cardTip = eachCustomerIncomeDict[keys.cardTip] as! Int
        cashTip = eachCustomerIncomeDict[keys.cashTip] as! Int
    }
}
