//
//  LoginViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/21/21.
//

import UIKit

// Provides the login authentication, and produces some data for the initial creation

class LoginViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    // MARK: - Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
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
                    let vc = storyBoard.instantiateViewController(withIdentifier: "FeedTableVC")
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(_):
                    let alertController = GlobalFunctions.basicOkAlert(title: "Sign in failed", message: "Email or Password was incorrect")
                    self.present(alertController, animated: true, completion: nil)
                    print("You failed!!! - No one should be able to see this...")
                } // End of Switch
            })
        } else {
            print("Error in \(#function)\(#line)")
        }
    } // End of Action

    // MARK: - Function
    func setupKeyboard() {
        self.emailField.keyboardType = .emailAddress
        self.emailField.textContentType = UITextContentType.username
        self.passwordField.textContentType = UITextContentType.password
    } // End of Func setup Keyboard
    
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    func validateFields() -> Bool {
        // Simply checks if the fields are not empty
        if emailField.text == "" ||
            passwordField.text == "" {
            let alert = GlobalFunctions.basicOkAlert(title: "Login failed!", message: "Please enter Email and Password!")
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            print("Email and Password cleared!")
            return true
        }
    } // End of Function
    
} // End of Class
