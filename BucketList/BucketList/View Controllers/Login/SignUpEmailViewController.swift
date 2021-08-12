//
//  SignUpEmailViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/5/21.
//

import UIKit

class SignUpEmailViewController: UIViewController, UITextFieldDelegate {

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    // MARK: - Properties
    static var username: String?
    static var firstName: String?
    static var lastName: String?
    static var dob: Date?

    // MARK: - Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmEmailField: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    } // End of View did load
    
    
    // MARK: - Actions
    @IBAction func toPasswordBtn(_ sender: Any) {
        if validateEmail() == true {
            SignUpPasswordViewController.username = SignUpEmailViewController.username
            SignUpPasswordViewController.firstName = SignUpEmailViewController.firstName
            SignUpPasswordViewController.lastName = SignUpEmailViewController.lastName
            SignUpPasswordViewController.dob = SignUpEmailViewController.dob
            SignUpPasswordViewController.email = emailField.text
            let storyBoard: UIStoryboard = UIStoryboard(name: "Authenticate", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "signUpPasswordVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    } // End of To password Button
    

    // MARK: - Functions
    func setupKeyboard() {
        emailField.delegate = self
        confirmEmailField.delegate = self
        
        self.emailField.keyboardType = .emailAddress
        self.emailField.textContentType = .emailAddress
        
        self.confirmEmailField.keyboardType = .emailAddress
        self.confirmEmailField.textContentType = .emailAddress
    } // End of Func setupkeyboard
    
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    func validateEmail() -> Bool {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmEmailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Please fill out all fields")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if emailField.text != confirmEmailField.text {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Please confirm that emails match")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if GlobalFunctions.emailValidator(email: emailField.text!) != true {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Email address does not appear to be valid?")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    } // End of Validate Email

} // End of Class
