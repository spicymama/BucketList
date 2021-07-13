//
//  SignUpPasswordViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/5/21.
//

import UIKit

class SignUpPasswordViewController: UIViewController, UITextFieldDelegate {
    
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
        setupKeyboard()
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
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    func setupKeyboard() {
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
        
        //TODO(ethan) suggest a new password 
        self.passwordField.textContentType = .newPassword
        self.passwordField.isSecureTextEntry = true
        
        self.confirmPasswordField.isSecureTextEntry = true
        self.confirmPasswordField.textContentType = .password
    } // End of Function setup keyboard
    
    func validatePassword() -> Bool {
        if passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Please fill out all fields")
            self.present(alert, animated: true, completion: nil)
        }
        if passwordField.text != confirmPasswordField.text {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Passwords do not match")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if PasswordValidator.passwordValid(passwordField.text!) == false {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Password must have one capital letter and be between 6 and 24 characters")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    } // End of Validate Password
    
} // End of Class

