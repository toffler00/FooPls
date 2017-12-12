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
    
    
    //MARK: - Property
    let reference = Database.database().reference()
    let storage = Storage.storage().reference()
    let userInfo = Auth.auth().currentUser
    var postModel : PostModel?
    var currentUser : UserModel?
    var mainView : MainCollectionView?
    init() { }
    
    //completion 클로저 사용(네트워크가 완료되었을 때 실행시키는 방법에는 델리게이트, 노티피케이션, 클로져 방법이 있는데 그 중 클로저 사용.) 네트워크는 비동기이기 때문에 네트워크가 완료되었을 때 실행시켜주는 것이 필요함.

    
    func loadDataToMainCollectionView() {
        guard let uid = self.currentUser?.uid else {return}
        ref = Database.database().reference()
        ref.child("users").child(uid).child("posts").observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [ String: [String : String]] else {return}
            var datas = [self.postModel]
            for (_, dic) in data {
                guard let name = dic["sotrename"], let adress = dic["adress"],
                    let url = dic["imageurl"], let content = dic["content"] else {return}
                let urlString = URL(string: url)
                let imgData = try! Data(contentsOf: urlString!)
                let image = UIImage(data: imgData)
                let posts = PostModel(storeName: name, StoreAdress: adress, contentText: content, storeImg: image!)
                datas.append(posts)
               print(datas)
                
            }
        }
    }
    
    
    
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
    
    
//    // MARK: - fetchUser
//    func fetchUserUidAndPostsKey(completion : @escaping (_ key : String) -> Void) {
//        guard let uid = userInfo?.uid else {return}
//        let key = ref.child("users").child(uid).child("posts").childByAutoId().key
//        completion(key)
//    }
    
    
    // MARK: - upload
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
 
