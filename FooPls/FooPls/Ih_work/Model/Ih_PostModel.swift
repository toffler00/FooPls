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
    
    
    var storeLati : Double?
    var storeLongi : Double?
    var contentsText : String?
    var storeTag : String?
    var storeImg : UIImage?
    var storeImgUrl : String?
    var storeImgData : Data?  {
        if let image = storeImg
        {
            return UIImageJPEGRepresentation(image, 0.5)!
        }
        return nil
    }
    
    var postData : [PostModel] = []
    
    init(storeName : String, storeAddress : String,
         contentText : String, storeImgUrl : String){
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.contentsText = contentText
        self.storeImgUrl = storeImgUrl
    }
    init(storeName : String, StoreAddress : String, contentText : String, storeImg : UIImage) {
        self.storeName = storeName
        self.storeAddress = StoreAddress
        self.contentsText = contentText
        self.storeImg = storeImg
    }
    
    mutating func addPostInfo(widh dic : (key : String, value: String)){
        self.storeName = dic.value
        self.storeAddress = dic.value
        self.storeImgUrl = dic.value
        self.contentsText = dic.value
    }
}
