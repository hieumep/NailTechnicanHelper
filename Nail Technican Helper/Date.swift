//
//  Date.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/15/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation

struct Date{
    var compoments : NSDateComponents
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    var currentDate : NSDate? = nil
    
    init(date:NSDate){
        compoments = calendar.components([.Year,.Month,.Day], fromDate: date)
        currentDate = calendar.dateFromComponents(compoments)
    }
    
    init(date:NSDate, addDay : Int){
        let newDate = calendar.dateByAddingUnit(.Day, value: addDay, toDate: date, options:NSCalendarOptions.init(rawValue: 0))
        compoments = calendar.components([.Year,.Month,.Day,], fromDate: newDate!)
        currentDate = calendar.dateFromComponents(compoments)
    }
    
    func getStartDate() -> NSDate{
        compoments.hour = 0
        compoments.minute = 0
        compoments.second = 0
        print("test \(currentDate)")
        return currentDate!
    }
    
    func getEndDate() -> NSDate{
        let components = NSDateComponents()
        components.day = 1
        var endDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: currentDate!, options: [])!
        endDate = endDate.dateByAddingTimeInterval(-1)
        return endDate
    }
    
    func getStartDateString() -> String{
        dateFormatter.dateStyle = .MediumStyle
        compoments.hour = 0
        compoments.minute = 0
        let date = calendar.dateFromComponents(compoments)
        return dateFormatter.stringFromDate(date!)
    }
    
    func getEndDateString() -> String {
        compoments.hour = 23
        compoments.minute = 59
        let date = calendar.dateFromComponents(compoments)
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(date!)
    }
}
