//
//  ProfileCollectionViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/22/21.
//

import UIKit


class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    var text: String? {
        didSet {
            updateViews()
        }
    }
    override func awakeFromNib() {
         super.awakeFromNib()
         
         contentView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             contentView.leftAnchor.constraint(equalTo: leftAnchor),
             contentView.rightAnchor.constraint(equalTo: rightAnchor),
             contentView.topAnchor.constraint(equalTo: topAnchor),
             contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
         ])
     }
    func updateViews() {
        guard let text = text else {return}
        label.text = text
        imageView.image = UIImage(named: "peace")
    }
        func configure() {
        imageView.image = UIImage(named: "peace")
        label.text = "It worked!"
    }
}
