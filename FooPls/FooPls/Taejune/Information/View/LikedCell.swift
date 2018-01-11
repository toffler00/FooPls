//
//  LikedCell.swift
//  FooPls
//
//  Created by SIMA on 2018. 1. 11..
//  Copyright © 2018년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class LikedCell: UICollectionViewCell {
    
    @IBOutlet weak var likedImageView: UIImageView!
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var likedTitle: UILabel!
    @IBOutlet weak var likedDate: UILabel!
    @IBOutlet weak var likedAddress: UILabel!
    
    override func awakeFromNib() {
        likedButton.setImage( UIImage(named: "like"), for: .normal)
    }
}
