//
//  FollowingViewController.swift
//  FooPls
//
//  Created by SIMA on 2018. 1. 5..
//  Copyright © 2018년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class FollowingViewController: UIViewController {
    
    var reference: DatabaseReference = Database.database().reference()
    var userNickname: [String] = []
    var photoID: [String] = ["https://firebasestorage.googleapis.com/v0/b/foopls-84f76.appspot.com/o/profile_images%2FoGhvuXjLUmbpc223jv6PvD9Ymob2?alt=media&token=ad40a0a5-37dc-4988-88d4-2b121609e080",
                              "https://firebasestorage.googleapis.com/v0/b/foopls-84f76.appspot.com/o/profile_images%2Fkakao:574854846?alt=media&token=1c1cb979-2071-497c-bf30-6a67bce0793a",
                              "https://firebasestorage.googleapis.com/v0/b/foopls-84f76.appspot.com/o/profile_images%2Fgi3e4MdgpmYbu1kSis5RgQOzjSn2?alt=media&token=04e7c6a8-e49c-4b31-bbfb-f7a8557ad6a0",
                              "https://firebasestorage.googleapis.com/v0/b/foopls-84f76.appspot.com/o/profile_images%2FXkb2j6CvUPf1PJTjXeYYeDv1fIR2?alt=media&token=ea90a319-09fe-4175-a23c-5544787ae2fa"]
    
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
        cell.userImgView.kf.setImage(with: URL(string: self.photoID[indexPath.row]) )
        return cell
    }
    
    
}

extension FollowingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
