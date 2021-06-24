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
            // Create user via Firebase
//            FirebaseFunctions.createUser(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, dob: datePicker.date, username: usernameField.text!)
            print("User \(usernameField.text ?? "") created!")
            // Pop view
            navigationController?.popViewController(animated: true)
        } else {
            print("Error in \(#function)\(#line)")
        }
    } // End of Action
    
    
    // MARK: - Functions
    func validateFields() -> Bool {
        // Check that all fields are filled in
        if usernameField.text == "" ||
            emailField.text == "" {
            print("Fill out fields")
            return false
        } else {
            return true
        }
    }




    /*
    func validateFields() -> Bool {
        
        // Check if all fields are filled in
        if (usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                confirmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") ||
            // Edit this to check for agge restrictions (13 usually)
            datePicker.date == nil ||
            // This will make sure that both passwords are the same
            (passwordField.text != passwordField.text) ||
            // Thich checks password length
            (usernameField.text!.count < 16) {
        } else {
            // TODO - Display an alert
            print("Please fill out all fields")
            return false
        }
        if PasswordValidator.passwordValid(passwordField.text!) == false {
            // TODO - Display alert instead of print statement
            // TODO - Make this tell you what you did wrong... Pass info back and forth?
            print("Password must have one capital letter, one number, one symbol, and be between 6 and 16 characters")
            return false
        }
        return true
    } // End of Function
         */
    
} // End of Class
