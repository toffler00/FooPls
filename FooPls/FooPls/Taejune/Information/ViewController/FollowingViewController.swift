//
//  FollowingViewController.swift
//  FooPls
//
//  Created by SIMA on 2018. 1. 5..
//  Copyright © 2018년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import Firebase

class FollowingViewController: UIViewController {
    
    var reference: DatabaseReference = Database.database().reference()
    var userNickname: [String] = []
    
    @IBOutlet weak var followingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference.child("dummyData").child("followingUser").observe( .value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            guard let value = snapshot.value as? [String] else { return }
            for user in value {
                self.userNickname.insert(user, at: 0)
                print(self.userNickname)
                self.followingTableView.reloadData()
            }
        }
        
    }
    
    private func setupUI() {
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FollowingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNickname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowCell
        cell.usernameLabel.text = self.userNickname[indexPath.row]
       
        return cell
    }
    
    
}

extension FollowingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
