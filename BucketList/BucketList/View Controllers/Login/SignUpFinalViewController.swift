//
//  SignUpViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/21/21.
//

import UIKit

class SignUpFinalViewController: UIViewController {
    
    // MARK: - Properties
    static var email: String?
    static var password: String?
    static var firstName: String?
    static var lastName: String?
    static var dob: Date?
    static var username: String?
    
    // Verify all fields
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFinalView()
    } // End of View did load
    
    
    // MARK: - Actions

    @IBAction func signUpBtn(_ sender: Any) {
        // Create user via Firebase
        FirebaseFunctions.createUser(email: SignUpFinalViewController.email!,
                                     password: SignUpFinalViewController.password!,
                                     firstName: SignUpFinalViewController.firstName!,
                                     lastName: SignUpFinalViewController.lastName!,
                                     dob: SignUpFinalViewController.dob!,
                                     username: SignUpFinalViewController.username!)
        print("User \(SignUpFinalViewController.username ?? "") created!")
        // Pop view
        navigationController?.popToRootViewController(animated: true)
    } // End of Sign Up Button
    
    
    // MARK: - Functions
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    func updateFinalView() {
        usernameLabel.text = "Username: " + SignUpFinalViewController.username!
        emailLabel.text = "email: " + SignUpFinalViewController.email!
        nameLabel.text = ("Name: \(SignUpFinalViewController.firstName!) \(SignUpFinalViewController.lastName!)")
        birthDateLabel.text = "Birthday: " + SignUpFinalViewController.dob!.formatToString()
    } // End of Update Final View
    
} // End of Class

