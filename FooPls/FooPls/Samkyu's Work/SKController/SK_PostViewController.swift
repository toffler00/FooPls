//
//  SK_PostViewController.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 6..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase

class SK_PostViewController: UIViewController {
    
    @IBOutlet weak private var uploadedImgView1: UIImageView!
    @IBOutlet weak private var uploadedImgView2: UIImageView!
    @IBOutlet weak private var uploadedImgView3: UIImageView!
    
    @IBOutlet weak private var placeNameLB: UILabel!
    @IBOutlet weak private var addressLB: UILabel!
    
    var selectedPlace:String?
    var selectedAddress:String?
    var selectedLati:String?
    var selectedLongi:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeNameLB.text = selectedPlace
        addressLB.text = selectedLati
    }
    
    

}
