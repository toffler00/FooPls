//
//  FollowerCell.swift
//  FooPls
//
//  Created by SIMA on 2018. 1. 5..
//  Copyright © 2018년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class FollowCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(followBtn.isSelected)
        userImgView.layer.cornerRadius = userImgView.frame.width / 2
        userImgView.layer.borderWidth = 2
        userImgView.layer.borderColor = UIColor(red: 199.0/255.0, green: 234.0/255.0, blue: 70.0/255.0, alpha: 1.0).cgColor
        followBtn.layer.cornerRadius = followBtn.frame.height / 2
        followBtn.layer.borderWidth = 2
        followBtn.layer.borderColor = UIColor(red: 199.0/255.0, green: 234.0/255.0, blue: 70.0/255.0, alpha: 1.0).cgColor
        followBtn.addTarget(self, action: #selector(self.followBtnAction(_:)), for: .touchUpInside)
    }
    @objc func followBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            userImgView.layer.borderColor = UIColor.lightGray.cgColor
            sender.setTitle("+팔로우", for: .normal)
            sender.setTitleColor(UIColor(red: 199.0/255.0, green: 234.0/255.0, blue: 70.0/255.0, alpha: 1.0), for: .normal)
            sender.backgroundColor = UIColor.white
            sender.isSelected = false
        }else {
            userImgView.layer.borderColor = UIColor(red: 199.0/255.0, green: 234.0/255.0, blue: 70.0/255.0, alpha: 1.0).cgColor
            sender.setTitle("팔로잉", for: .normal)
            sender.backgroundColor = UIColor(red: 199.0/255.0, green: 234.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            sender.isSelected = true
        }
    }
}
