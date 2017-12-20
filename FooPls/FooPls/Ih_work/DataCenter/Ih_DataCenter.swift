//
//  DataCenter.swift
//  FooplsProject
//
//  Created by ilhan won on 2017. 11. 29..
//  Copyright © 2017년 ilhan won. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DataCenter {
    
    
    static var main = DataCenter()

    //GooglePlacePicker의 기본 데이터
    //37.5156778,127.0191916

    var latitude:Double = 37.5156778
    var longitude:Double = 127.0191916
    var placeAddress:String = "서울특별시 강남구 논현동"
    var placeName:String = "FooPls!"
    
    
    //MARK: - Property
    let reference = Database.database().reference()
    let storage = Storage.storage().reference()
    let userInfo = Auth.auth().currentUser
    var postModel : PostModel?
    var currentUser : UserModel?
    
    init() {}
    
    //completion 클로저 사용(네트워크가 완료되었을 때 실행시키는 방법에는 델리게이트, 노티피케이션, 클로져 방법이 있는데 그 중 클로저 사용.) 네트워크는 비동기이기 때문에 네트워크가 완료되었을 때 실행시켜주는 것이 필요함.


    // MARK: - load location Data
    func load(completion: @escaping ([LocationModel]) -> Void) {//[Position] 을 파라미터로 받는 completion 탈출클로저를 사용, 함수가 완료되는 시점에 클로저를 실행함.
        ref.child("latiAndLongi").observeSingleEvent(of: .value) { (snapshot) in //observeSingleEvent 사용
            if let values = snapshot.value as? [String : Any] {
                var temp: [LocationModel] = [] //클로저와 for in 구문을 한 번 사용하기 위해 [Position]타입 변수선언
                for (key, value) in values {
                    guard let lati = (value as? [String: Double])?["lati"],
                        let longi = (value as? [String: Double])?["longi"]
                    else { return }
                    let newPosition = LocationModel(latitude: lati, longitude: longi, title: key)
                    temp.append(newPosition)
                }
                completion(temp) //completion 클로저에 temp를 담아 실행.
            }
        }
    }
    
    //MARK: - Data singleEvent
    func dataLoadSingleEvent(completion : @escaping ([PostModel]) -> Void) {
        reference.child("users").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let users = snapshot.value as? [String : [String : [String : String]]] {
                var mainVCpostsData : [PostModel] = []
                for (_ , value) in users {
                    if mainVCpostsData.count <= 30 {
                        if let posts = value["posts"] {
                            let name = posts["storename"]
                            let address = posts["storeaddress"]
                            let content = posts["content"]
                            let imgurl = posts["storeimgurl"]
                            let lati = posts["latitude"]
                            let longi = posts["longitude"]
                            let thoughts = posts["thoughts"]
                            let date = posts["data"]
                            let timeStamp = posts["timestamp"]
                            let photoname = posts["photoname"]
                            let nickname = posts["nickname"]
                            let datas = PostModel(storeName: name!, storeAddress: address!, content: content!, latitude: lati!, longitude: longi!, storeImgurl: imgurl!, date: date!, timeStamp: timeStamp!, photoName: photoname!, thoughts : thoughts!, nickname : nickname!)
                            mainVCpostsData.append(datas)
                        }
                    }else {
                        return
                    }
                }
                completion(mainVCpostsData)
            }
        }
    }
    //MARK : -user Uid and nickname
    

//    func dbValueObserver() {
//        ref.child("users").observe(DataEventType.childAdded) { (snapshot) in
//            if let users = snapshot.value as? [String : [String : [String : String]]] {
//                if let posts = users["users"] as? [String : [String : String]] {
//                    for (_ , value) in posts {
//                        var name = value["storename"]
//                        var address = value["storeadress"]
//                        var content = value["content"]
//                        var imgurl = value["storeimgurl"]
//                        var lati = value["latitude"]
//                        var longi = value["longitude"]
//
//
//                    }
//
//                }
//            }
//        }
//    }
    
    // MARK: - upload
    func postingUpload() {
        
    }
    
    func postUpload(uid : String?, storeimg : UIImage, storeName : String,
                    storeAdress : String, contents : String) {
        guard ((postModel?.storeImg = storeimg) != nil) else {return}
        guard let img = postModel?.storeImgData else {return}
        Storage.storage().reference().child(uid!).child("storeimg").putData(img, metadata: nil) { (metadata, error) in
            guard let imgUrl = metadata?.downloadURL()?.absoluteString
                else {return}
            let dic = ["storename" : storeName,
                       "storeadress" : storeAdress,
                       "content" : contents,
                       "storeimgurl" : imgUrl] as [String : Any]
            Database.database().reference().child("users").child(uid!).child("posts")
                .childByAutoId().updateChildValues(dic) { (error, ref) in
                    if error != nil {
                        print(error.debugDescription)
                    }else {
                        print("업로드성공")
                    }
            }
        }
    }
    
    
}









