//
//  RecentPostsTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/24/21.
//

import UIKit


class RecentPostsTableViewCell: UITableViewCell {
static let shared = RecentPostsTableViewCell()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var string: String? {
        didSet {
         updateViews()
        }
    }

    func updateViews() {
        guard let string = string else {return}
        self.textLabel?.text = string
    }
}

