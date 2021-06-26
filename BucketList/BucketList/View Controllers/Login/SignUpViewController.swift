//
//  SignUpViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/21/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    } // End of Function
    
    
    // MARK: - Actions
    @IBAction func signUpBtn(_ sender: Any) {
        // Validate fields
        if validateFields() == true {
//             Create user via Firebase
                        FirebaseFunctions.createUser(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, dob: datePicker.date, username: usernameField.text!)
            print("User \(usernameField.text ?? "") created!")
            // Pop view
            navigationController?.popViewController(animated: true)
        } else {
            print("Error in \(#function)\(#line)")
        }
    } // End of Action
    
    
    // MARK: - Functions
    func validateFields() -> Bool {
        /*
        // Check that all fields are filled in
        if usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            datePicker.date == nil ||
            (passwordField.text != passwordField.text) ||
            (usernameField.text!.count < 16) {
            
            let alert = GlobalFunctions.basicOkAlert(title: "Failed to create User", message: "Please fill out all fields")
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            if PasswordValidator.passwordValid(passwordField.text!) == false {
                let alert = GlobalFunctions.basicOkAlert(title: "Failed to create User", message: "Password must have one capital letter, one number, one symbol, and be between 6 and 16 characters")
                self.present(alert, animated: true, completion: nil)
                return false
            }
 */
            return true
//        }
    } // End of Validate fields function
    
} // End of Class
