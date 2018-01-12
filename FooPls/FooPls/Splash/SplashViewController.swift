//
//  SplashViewController.swift
//  LogInSignUpProc

import UIKit
import SwiftKeychainWrapper
import Firebase
import FBSDKLoginKit

class SplashViewController: UIViewController {
    
    // MARK: property
    let loginSegue = "loginSegue"
    let mainSegue = "mainSegue"
    let followerUser = ["fastcampus","Taejune", "ilhan", "정태준", "Samuel Sam Kyu Kang"]
    let followingUser = ["fastcampus", "ilhan", "정태준", "Samuel Sam Kyu Kang"]
    
    @IBOutlet weak var fooplsLoadingView: FooPlsView!

    // MARK: Life Cycle
    override func viewDidLoad() {        
        super.viewDidLoad()
        Database.database().reference().child("dummyData").child("followerUser").setValue(followerUser)
        Database.database().reference().child("dummyData").child("followingUser").setValue(followingUser)
        DataCenter.main.dummyDataLoadSingleEvent()
        DataCenter.main.dataLoadSingleEvent() //{ (mainVCPostData) in
//            let mainVCData = mainVCPostData
//            NotificationCenter.default.post(name: Notification.Name.mainVCData, object: mainVCData)
//        }
        //MARK: - 애니메이션 동작, 동작 후 후행 클로저를 통해 현재 로그인이 되어 있는지 확인
        fooplsLoadingView.addSplashLoadingAnimation { [weak self] (action) in
            guard let `self` = self else { return }
            if let _ = Auth.auth().currentUser {
                DataCenter.main.getUserUidAndNickName()
                self.performSegue(withIdentifier: self.mainSegue, sender: self)
            }else {
                self.performSegue(withIdentifier: self.loginSegue, sender: self)
            }
        }
    }
}
