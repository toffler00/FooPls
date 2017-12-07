//
//  UserModel.swift
//  FooplsProject
//
//  Created by ilhan won on 2017. 11. 29..
//  Copyright © 2017년 ilhan won. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct UserModel{
    //user login info
    var email : String
    var uid : String
    
    var password : String?
    var token : String?
    var nickName : String?
    
//    init(email : String, uid : String){
//        self.email = email
//        self.uid = uid
//    }
//    //user info
//    var latitude : String?
//    var longitude : String?
//
}
