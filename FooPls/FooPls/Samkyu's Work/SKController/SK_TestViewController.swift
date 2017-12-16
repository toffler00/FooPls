//
//  SK_TestViewController.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 14..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class SK_TestViewController: UIViewController, GooglePlaceDataDelegate {

    @IBOutlet weak var Label: UILabel!
    
    func positinData(lati: Double, longi: Double, address: String, placeName: String) {
        
        Label.text = placeName
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
