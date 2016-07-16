//
//  TextUtilities.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 7/4/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation

class TextUtilities : NSObject {
    func stringToNumber(string : String) -> String {
        var text : String
        let number = Int(string)
        let centString = number! % 100
        let dollarString = number! / 100
        /*
        switch centString{
        case 0:
            text = "\(dollarString)"
        case 1...9 :
            text = "\(dollarString).0\(centString)"
        default :
            text = "\(dollarString).\(centString)"
        }
        */
        if centString < 10 {
            text = "\(dollarString).0\(centString)"
        }else {
            text = "\(dollarString).\(centString)"
        }
        return text
    }
    
    func stringToNumberNoZero(string : String) -> String {
        var text : String
        let number = Int(string)
        let centString = number! % 100
        let dollarString = number! / 100
        switch centString{
        case 0:
            text = "\(dollarString)"
        case 1...9 :
            text = "\(dollarString).0\(centString)"
        default :
            text = "\(dollarString).\(centString)"
        }
        return text
    }
    func stringToInt(text : String) -> Int {
        let newText = text.stringByReplacingOccurrencesOfString(".", withString: "")
        return Int(newText)!
    }
}
