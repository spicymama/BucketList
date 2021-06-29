//
//  CreateBucketViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/29/21.
//

import UIKit

class CreateBucketViewController: UIViewController {

    
    @IBOutlet weak var lilTableView: UITableView!
    
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
