//
//  AddBlockReportViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/30/21.
//

import UIKit
import FirebaseAuth

class AddBlockReportViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Actions
    @IBAction func addFriendBtn(_ sender: Any) {
    }
    
    @IBAction func messageBtn(_ sender: Any) {
    
    }
    
    @IBAction func blockBtn(_ sender: Any) {
    }
    
    @IBAction func reportBtn(_ sender: Any) {
        print("Report recieved. We will take good care of this, don't worry. This message is definitly getting sent to someone in charge that will definitly take care of this situation! Please allow 8-16 weeks for changes.")
    }
    
    @IBAction func signOutBtn(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let 🛑 as NSError {
            print("Error signing out: %@", 🛑)
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authenticate", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    } // End of Sign out button
    
} // End of Class
