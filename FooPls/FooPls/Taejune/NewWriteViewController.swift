//
//  NewWriteViewController.swift
//  FooPls
//
//  Created by SIMA on 2017. 12. 5..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class NewWriteViewController: UIViewController {

    var selectedDate: String = ""
    @IBOutlet weak var labelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.text = selectedDate
        
    }
}
