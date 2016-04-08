//
//  NailShop.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/4/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import CoreData

class NailShop : NSManagedObject{
    struct keys {
        static let nailShop = "nail_Shop"
        static let percent = "percent"
        static let phoneNumber = "phone_number"
        static let address = "address"
    }
    
    @NSManaged var nailShop : String
    @NSManaged var percent : NSNumber
    @NSManaged var phoneNumber : String?
    @NSManaged var address : String?
    @NSManaged var dailyIncomes : [DailyIncome]?
    @NSManaged var eachCustomerIncomes : [EachCustomerIncome]?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(nailShops : [String : AnyObject], context : NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("NailShop", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        let commision = nailShops[keys.percent] as! String
        nailShop = nailShops[keys.nailShop] as! String
        percent = Int(commision)!
        phoneNumber = nailShops[keys.phoneNumber] as? String
        address = nailShops[keys.address] as? String
    }
    
}
