//
//  SignUpPasswordViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/5/21.
//

import UIKit

class SignUpPasswordViewController: UIViewController {

    // MARK: - Properties
    static var username: String?
    static var firstName: String?
    static var lastName: String?
    static var dob: Date?
    static var email: String?
        
    
    // MARK: - Outlets
    // Password
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    } // End of View did load
    
    
    // MARK: - Actions
    @IBAction func finalCheckBtn(_ sender: Any) {
        if validatePassword() == true {
            SignUpFinalViewController.username = SignUpPasswordViewController.username
            SignUpFinalViewController.firstName = SignUpPasswordViewController.firstName
            SignUpFinalViewController.lastName = SignUpPasswordViewController.lastName
            SignUpFinalViewController.dob = SignUpPasswordViewController.dob
            SignUpFinalViewController.email = SignUpPasswordViewController.email
            SignUpFinalViewController.password = passwordField.text
            let storyBoard: UIStoryboard = UIStoryboard(name: "Authenticate", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "signUpFinalVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    } // End of Final check Button

    
    // MARK: - Functions

    func validatePassword() -> Bool {
        if passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        }
        if passwordField.text != confirmPasswordField.text {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Passwords do not match")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if PasswordValidator.passwordValid(passwordField.text!) == false {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Password must have one capital letter, one number, one symbol, and be between 6 and 16 characters")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    } // End of Validate Password
 
} // End of Class

