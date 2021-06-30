//
//  FriendsListTableViewCell.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/25/21.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
//MARK: - Outlets
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var signinLabel: UILabel!
    
    //MARK: -Properties
    
    
    
    //MARK: - Landing Pad
    var user: User? {
        didSet {
        updateViews()
    }
}
    
    
    
    func updateViews() {
        guard let user = user else {return}
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        signinLabel.text = user.username
        let profileToViewUID = user.uid
        
    }
}
