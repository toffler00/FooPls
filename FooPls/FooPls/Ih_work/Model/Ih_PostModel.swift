//
//  PostModel.swift
//  FooplsProject
//
//  Created by ilhan won on 2017. 12. 5..
//  Copyright © 2017년 ilhan won. All rights reserved.
//

import Foundation
import Photos

struct  PostModel {
    
    //MARK : - Variable

    var storeName : String?
    var storeAddress : String?
    var nickName : String?
    

    //Optional
    var contentsText : String?
    var postTitle : String?
    var storeImg : UIImage?
    var imageurl : String?
    var thoughts : String?
    var date : String?
    var timeStamp : String?
    var photoName : String?
    var author : String?
    var storeImgData : Data?{
        if let image = storeImg
        {
            return UIImageJPEGRepresentation(image, 0.5)!
        }
        return nil
    }
    
    var latitude : Double?
    var longitude : Double?
    
    var postData : [PostModel] = []
    
    //캘린더 사용할 때 사용할 모델
    init(storeName : String, storeAddress : String, contentText : String, storeImgUrl : String, date : String,  timeStamp : String, lati : Double, longi : Double, photoName : String, postTitle : String, nickname : String ) {
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.contentsText = contentText
        self.imageurl = storeImgUrl
        self.date = date
        self.timeStamp = timeStamp
        self.latitude = lati
        self.longitude = longi
        self.photoName = photoName
        self.postTitle = postTitle
        self.nickName = nickname
    }
    
    //포스팅 모델
    init(storeName : String, storeAddress : String, content : String, latitude : Double, longitude : Double, storeImgurl : String, date : String, timeStamp : String, photoName : String, thoughts : String , nickname : String) {
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.contentsText = content
        self.latitude = latitude
        self.longitude = longitude
        self.imageurl = storeImgurl
        self.date = date
        self.timeStamp = timeStamp
        self.photoName = photoName
        self.thoughts = thoughts
        self.nickName = nickname
    }
    
    //포스팅 이벤트 수신대기 메소드에서 대응해줄 모델
    init(storeName : String, storeAddress : String, contentText : String, storeImgurl : String, lati : Double, longi : Double, thoughts : String, nickname : String) {
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.contentsText = contentText
        self.imageurl = storeImgurl
        self.latitude = lati
        self.longitude = longi
        self.thoughts = thoughts
        self.nickName = nickname
    }
    
    //구글플레이스에서 정보가져올때
    init (lati : Double, longi : Double, address : String, placename : String ) {
        self.storeName = placename
        self.storeAddress = address
        self.latitude = lati
        self.longitude = longi
    }
    
    init (imageUrl : String, photoname : String) {
        self.imageurl = imageUrl
        self.photoName = photoname
    }
    
    //Any = [String : [ String : [String : String]]]
    init(dictionary : [String : Any]) {
            for (_ , data) in dictionary {
                if let posts = data as? [String : Any] {
                    self.storeName = posts["storename"] as? String
                    self.storeAddress = posts["storeaddress"] as? String
                    self.contentsText = posts["content"] as? String
                    self.imageurl = posts["storeimgurl"] as? String
                    self.latitude = posts["latitude"] as? Double
                    self.longitude = posts["longitude"] as? Double
                    self.thoughts = posts["thoughts"] as? String
                    self.date = posts["date"] as? String
                    self.timeStamp = posts["timestamp"] as? String
                    self.photoName = posts["photoname"] as? String
                    self.nickName = posts["nickname"] as? String
                }
            }
        
   
    }
    
}

