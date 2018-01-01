//
//  GradientView.swift
//  FooPls
//
//  Created by ilhan won on 2017. 12. 31..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class GradientView: UIViewController {

    @IBOutlet weak var writePostBtn: UIButton!
    @IBOutlet weak var writeCalendarBtn: UIButton!
    
    let gridientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeBtnLayout()
        setGradientLayer()
        self.view.layer.addSublayer(gridientLayer)
        
    }
   
    @IBAction func showPostingPage(_ sender: UIButton) {
       
    }
    
    @IBAction func showCalendarPage(_ sender: UIButton) {
        
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
extension GradientView {
    
    func writeBtnLayout() {
        writePostBtn.setTitle("리뷰 쓰기", for: UIControlState.normal)
        writePostBtn.titleLabel?.textColor = UIColor.white
        writePostBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        writeCalendarBtn.setTitle("캘린더에 쓰기", for: .normal)
        writeCalendarBtn.titleLabel?.textColor = UIColor.white
        writeCalendarBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func setGradientLayer() {
        gridientLayer.frame = self.view.bounds
        gridientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gridientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        gridientLayer.colors = [
            UIColor(red: 0.9803, green: 0.9372, blue: 0.2941, alpha: 0.8).cgColor,
            UIColor(red: 0.9803, green: 0.9372, blue: 0.2941, alpha: 0.3).cgColor,
            UIColor(red: 0.9803, green: 0.9372, blue: 0.2941, alpha: 0.0).cgColor
        ]
        
        gridientLayer.locations = [0.0 , 0.7 ,1.0]
    }
}
