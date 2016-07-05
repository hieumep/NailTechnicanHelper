//
//  TextFieldDelegate.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/3/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//
import Foundation
import UIKit

class TextFieldDelegate : NSObject, UITextFieldDelegate {
    
    let textUltilities = TextUtilities()
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "0.00"
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text!.isEmpty || textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var text : String = textField.text! + string
        if text.characters.count < 12 {
            var newText = text.stringByReplacingOccurrencesOfString(".", withString: "")
            if string == "" {
                newText = String(newText.characters.dropLast())
            }
            text = textUltilities.stringToNumber(newText)
            textField.text = text
        }
        return false
    }
}
