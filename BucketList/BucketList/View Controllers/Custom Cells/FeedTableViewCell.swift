//
//  FeedTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let shared = FeedTableViewCell()
    var username: String = ""
    
    // MARK: - Outlets
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    
    // MARK: - Properties
    var user: User?
    var post: Post? {
        didSet {
            FirebaseFunctions.fetchUserData(uid: post!.authorID) { fetchedUser in
                DispatchQueue.main.async {
                self.user = fetchedUser
                self.updateViews()
                }
            }
        }
    }
    
    // MARK: - LIfecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        guard let post = post else {return}
        usernameLabel.text = ((user?.username ?? "User") + " checked " + (post.bucketTitle ?? "something") + " off their list!")
        postImageView.image = UIImage(named: "lift")
        noteLabel.text = post.note
        postTitle.text = post.bucketTitle
        fetchProfilePic(pictureURL: user?.profilePicUrl ?? "") { result in
                self.profilePic.image = result
            }
    }
    func fetchProfilePic(pictureURL: String, completion: @escaping (UIImage) -> Void){
        guard let url = URL(string: pictureURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { 📀, _, 🛑 in
            guard let 📀 = 📀, 🛑 == nil else {
                print("Error in \(#function)\(#line)")
                return
            }
            DispatchQueue.main.async {
                guard let image = UIImage(data: 📀) else {return}
               //self.profilePic.image = image
               completion(image)
            } // End of Dispatch Queue
        })
        task.resume()
    }
    
    /*
    func removePrefix(url: String)-> String {
        var count = 0
        var url = url
        for i in url {
            if count <= 7 {
           guard let index = url.firstIndex(of: i) else {return ""}
            url.remove(at: index)
            count += 1
            }
        }
        return url
    }

} // End of Feed Table View Cell
