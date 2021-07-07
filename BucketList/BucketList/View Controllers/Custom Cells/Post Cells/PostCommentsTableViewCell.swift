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
   
    func updateViews() {
        guard let comment = comment else {return}
        print(comment)
        self.textLabel?.text = comment
    }
}
