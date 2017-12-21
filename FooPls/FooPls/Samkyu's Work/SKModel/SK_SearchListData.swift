//
//  SK_SearchListData.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 20..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase


//파이어 베이스로 읽었을때, 로딩 되는 데이터를 가지고 옵니다.
struct AddressData {
    
    let placeName:String?
    let placeAddress:String?
    let writtenDate:String?
    let photoUrl:String?
    let comment:String?
    
    init?(firebaseData: [String:Any])
    {
        guard let placeName = firebaseData["storename"] as? String else { return nil }
        self.placeName = placeName
        guard let placeAddress = firebaseData["storeaddress"] as? String else { return nil }
        self.placeAddress = placeAddress
        guard let writtenDate = firebaseData["date"] as? String else { return nil }
        self.writtenDate = writtenDate
        guard let photoUrl = firebaseData["imageurl"] as? String else { return nil }
        self.photoUrl = photoUrl
        guard let comment = firebaseData["title"] as? String else { return nil }
        self.comment = comment
        
    }
}


class SearchedData {
    
    
    
    init(){ }
    
    func loadToFirebase(address: String, completion:@escaping ([AddressData])->Void){
        
        let checker = address
        var dataFromFirebase = ""
        
        
        
        ref = Database.database().reference()
        ref.child("users").child("YoHvSrPEi7bMuS1GjI2bQi1yYOG2").child("posts").observe(.value) { (Data) in
            
            var foundDatas:[AddressData] = []
            // 각 루트별로 데이터를 가져오는 아이템을 가져온다.
            for (_, rawData) in (Data.value as? [String:[String:Any]])! {
                //print(rawData)
                guard let address = rawData["storename"] as? String else { return }
                dataFromFirebase = address
                print("RawData 일치여부?")
                print(dataFromFirebase)
                
                if dataFromFirebase == checker {
                  print("대상이 있습니다.")
                print(rawData)
                    if let downloadedData = AddressData(firebaseData: rawData) {
                        foundDatas.append(downloadedData)
                    }
                }else{
                    //print("대상이 없습니다")
                }
            }
        completion(foundDatas)
        print("클로저 동작?:", foundDatas)
        }
    }
}
