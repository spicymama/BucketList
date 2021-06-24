//
//  LoginViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/21/21.
//

import UIKit

/// Provides the login authentication, and produces some data for the initial creation

class LoginViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    // MARK: - Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        konamiLoginFunc()
    } // End of Function
    
    func konamiLoginFunc() {
        emailField.text = "AndersenEthanG@gmail.com"
        passwordField.text  = "Str0ngP@ssw0rd."
    }
    
    // MARK: - Actions
    @IBAction func loginBtn(_ sender: Any) {
        // Validate
        if validateFields() == true {
            // Firebase login stuff
            FirebaseFunctions.signInUser(email: emailField.text!, password: passwordField.text!, 🐶: { result in
                switch result {
                case .success(_):
                    let storyBoard: UIStoryboard = UIStoryboard(name: "gavin", bundle: nil)
                    let vs = storyBoard.instantiateViewController(withIdentifier: "FeedTableVC")
                    self.navigationController?.pushViewController(vs, animated: true)
                case .failure(_):
                    // TODO: - Turn this into an alert
                    print("You failed!!! See error whatever something going on here for details... If you ever see this... The project never saw the light of day...")
                } // End of Switch
            })
        } else {
            print("Error in \(#function)\(#line)")
        }
    } // End of Action
    
    
    // MARK: - Function
    func validateFields() -> Bool {
        // Simply checks if the fields are not empty
        if emailField.text == "" ||
            passwordField.text == "" {
            // TODO: - Make this an alert
            print("Please enter username and password fields")
            return false
        } else {
            // TODO: - Make this an alert
            print("Username and Password fields cleared!")
            return true
        }
    } // End of Function
    
} // End of Class
