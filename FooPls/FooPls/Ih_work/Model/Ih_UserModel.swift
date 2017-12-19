
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
    
    
    init(email : String, uid : String){
        self.email = email
        self.uid = uid
    }
    
    
    
}

