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
import Firebase

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
    var imageInfo : PostModel?
    var postsData : PostModel?
     var mainVCpostsData : [PostModel] = []
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
    
    //MARK : - get user uid and nickName
    func getUserUidAndNickName() {
        guard let user = Auth.auth().currentUser else {return}
        let uid = user.uid
        let email = user.email
        reference.child("users").child(uid).child("profile").observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String : String] else {return}
            guard let nickName = data["nickname"] else {return}
            self.currentUser = UserModel(uid: uid, nickname: nickName, email: "sky4411v@gmail.com")
           
        }
    }
    
    //MARK: - Data singleEvent
    func dataLoadSingleEvent() {
        reference.child("users").observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            //Any = [String : [ String : [String : String]]]
            
            var dataDic : [[String : Any]] = []
            if let dic = snapshot.value as? [String : Any] {
                for (_ , temp) in dic {
                    if let posts = temp as? [String : Any] {
                        if let autoIDs = posts["posts"] as? [String : Any] {
                            dataDic.append(autoIDs)
                            print(dataDic.count)
                        }
                    }
                }
                for temp in dataDic {
                    let datas = PostModel(dictionary: temp)
                    self.mainVCpostsData.append(datas)
                    print(self.mainVCpostsData.count)
                }
            }
        }
    }

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
    func postingUpload(uid : String, storeName: String, storeAddress: String, content: String, latitude: String, longitude: String, storeImgurl: String, date: String, timeStamp: String, photoName: String, thoughts: String, nickname: String) {
        
        let postDic = ["storename" : storeName, "storeaddress" : storeAddress,
                       "content" : content, "latitude" : latitude, "longitude" : longitude,
                       "storeimgurl" : storeImgurl, "date" : date, "timeStamp" : timeStamp,
        "photoname" : photoName, "thoughts" : thoughts, "nickname" : nickname] as [String: String]
        reference.child("users").child(uid).child("posts").childByAutoId().updateChildValues(postDic) { (error, ref) in
            if error != nil {
                print(error.debugDescription)
            }else {
                print("업로드성공")
            }
        }
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
    
    //MARK : - Upload Image to firebase storage and get url
    func uploadImgAndgetUrl(selectedImg : UIImage){
        let img = UIImageJPEGRepresentation(selectedImg, 0.5)
        let autoID = NSUUID().uuidString
        let uid = currentUser?.uid
        print(uid!)
        Storage.storage().reference().child(uid!).child(autoID).putData(img!, metadata: nil) { (metadata, error) in
            guard let photoName = metadata?.name,
                let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
            self.imageInfo = PostModel(imageUrl: imageUrl, photoname: photoName)
        }
    }
    
}









