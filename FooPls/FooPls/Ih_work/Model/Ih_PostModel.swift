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
    var storeName : String
    var storeAdress : String
//    var storeLati : Double?
//    var storeLongi : Double?
    var contentsText : String?
//    var storeTag : String? tag는 추후
    
    var storeImg : UIImage?
    var storeImgUrl : String?
    var storeImgData : Data?  {
        if let image = storeImg
        {
            return UIImageJPEGRepresentation(image, 0.5)!
        }
        return nil
    }
    
    
    init(storeName : String, storeAdress : String,
         contentText : String, storeImgUrl : String){
        self.storeName = storeName
        self.storeAdress = storeAdress
        self.contentsText = contentText
        self.storeImgUrl = storeImgUrl
    }
    init(storeName : String, StoreAdress : String, contentText : String, storeImg : UIImage) {
        self.storeName = storeName
        self.storeAdress = StoreAdress
        self.contentsText = contentText
        self.storeImg = storeImg
    }
    
    mutating func addPostInfo(widh dic : (key : String, value: String)){
        self.storeName = dic.value
        self.storeAdress = dic.value
        self.storeImgUrl = dic.value
        self.contentsText = dic.value
    }
}
