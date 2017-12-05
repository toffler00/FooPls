//
//  SK_DetailViewController.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 5..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class SK_DetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var uploadedImageView: UIImageView!
    
    var nameTitle:String?
    var postedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLB.text = nameTitle
        uploadedImageView.image = postedImage

    }



}
