//
//  SignUpPersonalViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/5/21.
//

import UIKit

class SignUpPersonalViewController: UIViewController, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
    } // End of View did load
    
    
    // MARK: - Actions
    @IBAction func toEmailBtn(_ sender: Any) {
        if validatePersonalInformation() == true {
            SignUpEmailViewController.username = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            SignUpEmailViewController.firstName = firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            SignUpEmailViewController.lastName = lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            SignUpEmailViewController.dob = datePicker.date
            let storyBoard: UIStoryboard = UIStoryboard(name: "Authenticate", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "signUpEmailVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    } // End of To email Button
    
    
    @IBAction func dobPickerTap(_ sender: Any) {
        self.view.endEditing(true)
    } // End of Function
    
    // MARK: - Functions
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    
    func validatePersonalInformation() -> Bool {
        // Check for filled in fields
        if usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = GlobalFunctions.basicOkAlert(title: "Error", message: "Please fill out all fields")
            self.present(alert, animated: true, completion: nil)
            return false
        } // End of Text checks
        // Check if username is avaliable
        guard let username = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
        if username.count < 4 {
            let alert = GlobalFunctions.basicOkAlert(title: "Username too short", message: "Username must be at least 4 characters")
            self.present(alert, animated: true, completion: nil)
            return false
        }
        FirebaseFunctions.usernameIsAvaliable(username: username) { result in
            if result == false {
                let alert = GlobalFunctions.basicOkAlert(title: "Username not avaliable", message: "Please select a different one")
                self.usernameField.text = ""
                self.navigationController?.popViewController(animated: true)
                self.present(alert, animated: true, completion: nil)
            }
        } // End of Username Check
        return true
    } // End of Validate Personal Information
    
} // End of Class

