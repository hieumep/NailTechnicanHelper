//
//  Date.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/15/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation

struct Date{
    //var year : Int
    //var month : Int
    //var day : Int
    var compoments : NSDateComponents
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    
    init(date:NSDate){
        compoments = calendar.components([.Year,.Month,.Day], fromDate: date)
    }
    
    init(date:NSDate, addDay : Int){
        let newDate = calendar.dateByAddingUnit(.Day, value: addDay, toDate: date, options:NSCalendarOptions.init(rawValue: 0))
        compoments = calendar.components([.Year,.Month,.Day], fromDate: newDate!)
    }
    
    func getStartDate() -> NSDate{
        compoments.hour = 0
        compoments.second = 0
        let date = calendar.dateFromComponents(compoments)
        return date!
    }
    
    func getEndDate() -> NSDate{
        compoments.hour = 23
        compoments.second = 59
        let date = calendar.dateFromComponents(compoments)
        return date!
    }
    
    func getStartDateString() -> String{
        dateFormatter.dateStyle = .MediumStyle
        compoments.hour = 0
        compoments.second = 0
        let date = calendar.dateFromComponents(compoments)
        return dateFormatter.stringFromDate(date!)
    }
    
    func getEndDateString() -> String {
        compoments.hour = 23
        compoments.second = 59
        let date = calendar.dateFromComponents(compoments)
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(date!)    }
}
