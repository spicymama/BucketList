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
    @IBOutlet weak var loginBtn: UIButton!
    
    
    // MARK: - Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: true);
        setupKeyboard()
    } // End of Function
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    
    // MARK: - Actions
    @IBAction func loginBtn(_ sender: Any) {
        // Disable login button
        loginBtn.isUserInteractionEnabled = false
        loginBtn.isEnabled = false
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
        // Enable login button
        loginBtn.isUserInteractionEnabled = true
        loginBtn.isEnabled = true
    } // End of Action

    // MARK: - Function
    func setupKeyboard() {
        //TODO(ethan) Auto fill doesn't work, make this two items?
        self.emailField.keyboardType = .emailAddress
        self.emailField.textContentType = .emailAddress
        
        self.passwordField.isSecureTextEntry = true
        self.passwordField.textContentType = .password
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
