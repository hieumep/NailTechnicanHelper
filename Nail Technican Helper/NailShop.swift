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
        static let selected = "selected"
    }
    
    @NSManaged var nailShop : String
    @NSManaged var percent : NSNumber
    @NSManaged var phoneNumber : String?
    @NSManaged var address : String?
    @NSManaged var selected : Bool
    @NSManaged var dailyIncomes : [DailyIncome]?
    @NSManaged var eachCustomerIncomes : [EachCustomerIncome]?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(nailShops : [String : AnyObject], context : NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: "NailShop", in: context)!
        super.init(entity: entity, insertInto: context)
        percent = nailShops[keys.percent] as! NSNumber
        nailShop = nailShops[keys.nailShop] as! String
        phoneNumber = nailShops[keys.phoneNumber] as? String
        address = nailShops[keys.address] as? String
        selected = false
    }
    
}
