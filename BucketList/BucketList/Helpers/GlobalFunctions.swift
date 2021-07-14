//
//  GlobalFunctions.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/24/21.
//

import UIKit

class GlobalFunctions: UITableViewController {
    
    // MARK: - Basic alert
    static func basicOkAlert(title: String, message: String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    } // End of Basic cancel alert
    
    
    // MARK: - Email Verification
    static func emailValidator(email: String) -> Bool {
        
        var isEmailValid = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                isEmailValid = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            isEmailValid = false
        }
        
        return isEmailValid
    } // End of Email verification
    
    
    // MARK: - Hex color translator
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
} // End of Class Global Functions
