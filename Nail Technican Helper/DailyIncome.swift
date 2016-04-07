//
//  IncomeDaily.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/5/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import CoreData

class IncomeDaily : NSManagedObject {
    struct keys {
        static let date = "date"
        static let income = "income"
        static let cardTip = "card_tip"
        static let cashTip = "cash_tip"
        static let photo = "photo_path'"
    }
    
    @NSManaged var date : NSDate
    @NSManaged var income : Int
    @NSManaged var cardTip : Int
    @NSManaged var cashTip : Int
    @NSManaged var photo : String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(incomeDailyDict : [String : AnyObject], context : NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("In", inManagedObjectContext: <#T##NSManagedObjectContext#>)
    }
}
