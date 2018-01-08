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
        userImgView.layer.cornerRadius = userImgView.frame.width / 2
        userImgView.layer.borderWidth = 2
        userImgView.layer.borderColor = UIColor.lightGray.cgColor
        followBtn.layer.cornerRadius = followBtn.frame.height / 2
    }
}
