//
//  PasswordValidator.swift
//  Authenticator
//
//  Created by Ethan Andersen on 6/15/21.
//

import Foundation

class PasswordValidator {
    
    static func passwordValid(_ password: String) -> Bool {
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z]).{6,24}$")
        
        return passwordCheck.evaluate(with: password)
    } // End of Function
    
} // End of Class
