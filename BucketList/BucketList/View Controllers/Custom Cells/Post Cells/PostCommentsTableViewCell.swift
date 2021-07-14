//
//  PostCommentsTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 7/1/21.
//

import UIKit

class PostCommentsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var comment: String? {
        didSet {
            updateViews()
        }
    }
   
    // Makes the keyboard appear and dissapera
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentView.endEditing(true)
    } // End of Function
    
    func updateViews() {
        guard let comment = comment else {return}
        print(comment)
        self.textLabel?.text = comment
    }
}
