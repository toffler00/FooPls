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
    var storeName : String
    var storeAddress : String
    var nickName : String?
    //Optional
    var contentsText : String?
    var postTitle : String?
    var storeImg : UIImage?
    var storeImgUrl : String?
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
        self.storeImgUrl = storeImgUrl
        self.date = date
        self.timeStamp = timeStamp
        self.latitude = lati
        self.longitude = longi
        self.photoName = photoName
        self.postTitle = postTitle
        self.nickName = nickname
    }
    
    //포스팅 모델
    init(storeName : String, storeAddress : String, content : String, latitude : String, longitude : String, storeImgurl : String, date : String, timeStamp : String, photoName : String, thoughts : String , nickname : String) {
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.contentsText = content
        self.latitude = Double(latitude)
        self.longitude = Double(longitude)
        self.storeImgUrl = storeImgurl
        self.date = date
        self.timeStamp = timeStamp
        self.photoName = photoName
        self.thoughts = thoughts
        self.nickName = nickname
    }
    
    //포스팅 이벤트 수신대기 메소드에서 대응해줄 모델
    init(storeName : String, storeAddress : String, contentText : String, storeImgurl : String, lati : Double, longi : Double, thoughts : String) {
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.contentsText = contentText
        self.storeImgUrl = storeImgurl
        self.latitude = lati
        self.longitude = longi
        self.thoughts = thoughts
    }
    
    //구글플레이스에서 정보가져올때
    init (lati : Double, longi : Double, address : String, placename : String ) {
        self.storeName = placename
        self.storeAddress = address
        self.latitude = lati
        self.longitude = longi
    }
}
