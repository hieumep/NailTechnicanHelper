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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "0.00"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty || textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text : String = textField.text! + string
        if text.characters.count < 12 {
            var newText = text.replacingOccurrences(of: ".", with: "")
            if string == "" {
                newText = String(newText.characters.dropLast())
            }
            text = textUltilities.stringToNumber(newText)
            textField.text = text
        }
        return false
    }
}
