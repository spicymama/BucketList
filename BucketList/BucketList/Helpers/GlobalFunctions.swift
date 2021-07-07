//
//  GlobalFunctions.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/24/21.
//

import UIKit

class GlobalFunctions: UITableViewController {
    
    static func basicOkAlert(title: String, message: String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    } // End of Basic cancel alert
    
} // End of Class Global Functions
