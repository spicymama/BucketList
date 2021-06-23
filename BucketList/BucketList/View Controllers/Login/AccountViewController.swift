//
//  AccountViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/21/21.
//

import UIKit

class AccountViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Functions
    func updateView() {
        // Fetch data
        FirebaseFunctions.fetchCurrentUserData { data in
            // Update outlets
            self.firstNameLabel.text = data.firstName
            self.lastNameLabel.text = data.lastName
        }
    } // End of Function fetch data
    
    
} // End of Class
