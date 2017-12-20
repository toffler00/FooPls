
import Foundation
import FirebaseDatabase
import FirebaseAuth

struct UserModel{
    
    //Mark: Variable
    var email : String
    var uid : String
    
    //optional
    var password : String?
    var token : String?
    var nickName : String?
    var profileImg : UIImage?
    var profileImgurl : String?
    
    
    init(email : String, uid : String){
        self.email = email
        self.uid = uid
    }
    
    init(uid : String , nickname : String, email : String) {
        self.uid = uid
        self.nickName = nickname
        self.email = email
    }
    
}

