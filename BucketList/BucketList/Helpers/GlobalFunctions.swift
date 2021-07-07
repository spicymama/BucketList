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
    
} // End of Class Global Functions
