//
//  SearchResultTableViewCell.swift
//  FooPls
//
//  Created by Samuel K on 2018. 1. 5..
//  Copyright © 2018년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var uploadedImage:UIImageView!
    @IBOutlet weak var usernameLB:UILabel!
    @IBOutlet weak var addressNameLB:UILabel!
    @IBOutlet weak var commentLB:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
