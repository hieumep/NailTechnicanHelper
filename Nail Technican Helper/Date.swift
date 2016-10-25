//
//  Date.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/15/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation

struct DateConvenient{
    var compoments : DateComponents
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var currentDate : Date? = nil
    
    init(date: Date){
        compoments = (calendar as NSCalendar).components([.year,.month,.day], from: date)
        currentDate = calendar.date(from: compoments)
    }
    
    init(date: Date, addDay : Int){
        let newDate = (calendar as NSCalendar).date(byAdding: .day, value: addDay, to: date, options:NSCalendar.Options.init(rawValue: 0))
        compoments = (calendar as NSCalendar).components([.year,.month,.day,], from: newDate!)
        currentDate = calendar.date(from: compoments)
    }
    
    mutating func getStartDate() -> Foundation.Date{
        compoments.hour = 0
        compoments.minute = 0
        compoments.second = 0
        print("test \(currentDate)")
        return currentDate!
    }
    
    func getEndDate() -> Date{
        var components = DateComponents()
        components.day = 1
        var endDate = (Calendar.current as NSCalendar).date(byAdding: components, to: currentDate!, options: [])!
        endDate = endDate.addingTimeInterval(-1)
        return endDate
    }
    
    mutating func getStartDateString() -> String{
        dateFormatter.dateStyle = .medium
        compoments.hour = 0
        compoments.minute = 0
        let date = calendar.date(from: compoments)
        return dateFormatter.string(from: date!)
    }
    
    mutating func getEndDateString() -> String {
        compoments.hour = 23
        compoments.minute = 59
        let date = calendar.date(from: compoments)
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date!)
    }
}
