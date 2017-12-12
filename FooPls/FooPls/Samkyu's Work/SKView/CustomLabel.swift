//
//  CustomLabel.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 12..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    
    override func awakeFromNib() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        
    }
    

}
