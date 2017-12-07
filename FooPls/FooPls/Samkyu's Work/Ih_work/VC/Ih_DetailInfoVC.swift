//
//  DetailInfoVC.swift
//  FooplsProject
//
//  Created by ilhan won on 2017. 11. 30..
//  Copyright © 2017년 ilhan won. All rights reserved.
//

import UIKit

class DetailInfoVC: UIViewController {
    
    var titleLB : UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        lb.backgroundColor = UIColor.green
        return lb
    }()
    var latitudeLB : UILabel = {
        let latilb = UILabel()
        latilb.frame = CGRect(x: 100, y: 150, width: 100, height: 30)
        latilb.backgroundColor = UIColor.yellow
        return latilb
    }()
    
    var longitudeLB : UILabel = {
        let longilb = UILabel()
        longilb.frame = CGRect(x: 100, y: 200, width: 100, height: 30)
        longilb.backgroundColor = UIColor.cyan
        return longilb
    }()
    
    private var markerData : MapVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(titleLB)
        self.view.addSubview(latitudeLB)
        self.view.addSubview(longitudeLB)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "세부정보"
        self.navigationController?.navigationBar.backgroundColor = .yellow
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(handleNextVC))
    }
    @objc func handleCancel() {
        print("back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextVC() {
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
