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

/*
address:
"서울특별시 강남구 논현동"
close
author:
"Taejune"
content:
"글 내용"
date:
"2017년 12월 21일"
latitude:
37.5156778
locationTitle:
"FooPls!"
longitude:
127.0191916
photoID:
"https://firebasestorage.googleapis.com/v0/b/foo..."
photoName:
"0A3AD170-1F14-4354-8530-EA142C05C1B8"
postTime:
1513700601268
title:
"test"
 */




//파이어 베이스로 읽었을때, 로딩 되는 데이터를 가지고 옵니다.
struct AddressData {
    
    private let placeName:String?
    private let placeAddress:String?
    private let writtenDate:String?
    private let photoUrl:String?
    private let comment:String?
    
    init?(firebaseData: [String:Any])
    {
        guard let placeName = firebaseData["locationTitle"] as? String else { return nil }
        self.placeName = placeName
        guard let placeAddress = firebaseData["address"] as? String else { return nil }
        self.placeAddress = placeAddress
        guard let writtenDate = firebaseData["date"] as? String else { return nil }
        self.writtenDate = writtenDate
        guard let photoUrl = firebaseData["photoID"] as? String else { return nil }
        self.photoUrl = photoUrl
        guard let comment = firebaseData["title"] as? String else { return nil }
        self.comment = comment
        
    }
}


class SearchedData {
    
    var foundDatas:[AddressData] = []
    
    init(){
        loadToFirebase()
    }
    
    func loadToFirebase(){
        
        let checker = "라멘모토"
        var dataFromFirebase = ""
        
        ref = Database.database().reference()
        ref.child("users").child("YoHvSrPEi7bMuS1GjI2bQi1yYOG2").child("posts").observe(.value) { (Data) in
            
            // 각 루트별로 데이터를 가져오는 아이템을 가져온다.
            for (_, rawData) in (Data.value as? [String:[String:Any]])! {
                print(rawData)
                
                guard let address = rawData["locationTitle"] as? String else { return }
                dataFromFirebase = address
                
                if dataFromFirebase == checker {
                  print("대상이 있습니다.")
                }else{
                    print("대상이 없습니다")
                }
            }

            
        }
        
    }
}
