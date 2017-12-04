//
//  FirebaseSampleVC.swift
//  (1126)GoogleMapsSample
//
//  Created by Samuel K on 2017. 11. 29..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


class SKFirebaseInputVC: UIViewController {
    
    //위도 경도 데이터를 입력할 TF를 생성한다.
    @IBOutlet weak var lati: UITextField!
    @IBOutlet weak var longi: UITextField!
    
    //실제 위도, 경도 Data를 가져올 변수를 선언한다.
    var latiData:Double?
    var longiData:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func inputSample(_ sender: Any) {
        
        //firebase의 Data를 사용하기 위한 dataBase를 확인한다.
        ref = Database.database().reference()
        
        self.latiData = Double(lati.text!)
        self.longiData = Double(longi.text!)
        
        //데이터를 어떤식으로 전달할 것인지 형식을 정하여 준다.
        //Data를 Upload할때 어떤 식으로 DataModel을 구성하면 좋은지 연구하여 본다.
        
        let value = ["lati":latiData, "longi":longiData]
        
        //현재 데이터 베이스에 오토ID를 생성하고, 각 데이터를 저장하여 준다.
        ref.child("latiAndLongi").childByAutoId().setValue(value)
        print("에러처리 : ", ref.debugDescription)
        
    }
}
