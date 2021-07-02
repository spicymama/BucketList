//
//  BucketItemTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 7/1/21.
//

import UIKit

class BucketItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var progressButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func progressButtonTapped(_ sender: Any) {
    }
    
   

    var item: String? {
        didSet {
           updateViews()
        }
    }
    func updateViews() {
        itemLabel.text = item
    }
    
}
