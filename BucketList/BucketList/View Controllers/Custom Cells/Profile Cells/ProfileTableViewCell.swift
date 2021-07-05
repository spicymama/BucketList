//
//  ProfileTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit
import Firebase
import FirebaseStorage


class ProfileTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let storage = Storage.storage().reference()
    static let shared = ProfileTableViewCell()
    static var post: Post?
    static var profileUser: User?
    var buckitz: [Bucket] = []
    
        @IBOutlet weak var profilePic: UIImageView!
        @IBOutlet weak var usernameLabel: UILabel!
        @IBOutlet weak var publicListTableView: UITableView!
        @IBOutlet weak var imageView1: UIImageView!
        @IBOutlet weak var achievementLabel: UILabel!
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var lilTableView: UITableView!
    
        var strings = ["Climb Mountain", "Go to Disneyland", "Fly in a small plane", "see a whale", "Hug a panda"]
        
        override func awakeFromNib() {
            super.awakeFromNib()
            lilTableView.delegate = self
            lilTableView.dataSource = self
            collectionView.delegate = self
            collectionView.dataSource = self
        
            updateViews()
        }
    @IBAction func profilePicButtonTapped(_ sender: Any) {
        
        
    }
   
        func updateViews(){
            guard let user = ProfileTableViewCell.profileUser else {return}
            BucketFirebaseFunctions.fetchBuckets { result in
                self.buckitz = result
                print(self.buckitz)
            }
            profilePic.image = UIImage(named: "swing")
            usernameLabel.text = user.username
          //  achievementLabel.text = user.
            imageView1.image = UIImage(named: "lift")
            collectionView.contentSize = CGSize(width: 2000, height: 100)
            collectionView.addSubview(UIImageView())
        }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
        // Grab the image as an image
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        // Grab image data
        guard let imageData = image.pngData() else { return }
       // guard let title = imageTitleField.text else { return }
        //guard let creator = creatorNameField.text else { return }
        
        // This is the Firebase save stuff
        // This is where you set the file name, this should be random or something I guess
        let ref = storage.child("images/file.png")
        // This is the Firebase command bit to actually store things
        ref.putData(imageData, metadata: nil, completion: { _, 🛑 in
            // Error handling
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
                return
            }
            // Download a url
            ref.downloadURL(completion: { url, 🛑 in
                if let 🛑 = 🛑 {
                    print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
                }
                
                guard var urlString = url?.absoluteString else {return}
                UserDefaults.standard.set(urlString, forKey: "url")
                
                let newUrlString = self.removePrefix(url: urlString)
                let documentref = Firestore.firestore().collection("photourls").document("url")
                documentref.setData(["url" : urlString]) { error in
                    if let error = error {
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                    print(newUrlString)
                }
            }) // End of Download URL
        }) // End of Firebase stuff
    } // End of Function
    
    // When the user clicks away
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    } // End of Function

    func removePrefix(url: String)-> String {
        var count = 0
        var url = url
        for i in url {
            if count <= 7 {
            guard let index = url.firstIndex(of: i) else {return "problem"}
            url.remove(at: index)
            count += 1
            }
        }
        return url
    }
}
    extension ProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
            let text = "Recent Accomplishment..."
            cell.text = text
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = frame.width * 0.75
            return CGSize(width: width, height: 120)
        }
        
        
}

extension ProfileTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, numberOfRowsInSection section: Int) -> Int {
        buckitz.count
    }
    
    func tableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentPostCell", for: indexPath) as? RecentPostsTableViewCell else {return UITableViewCell()}
        let string = buckitz[indexPath.row].title
    cell.string = string
    return cell
}
    }

