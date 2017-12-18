//
//  SettingTableViewController.swift
//  FooPls
//
//  Created by SONGYEE SHIN on 2017. 12. 15..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FacebookCore
import FirebaseStorage

class SettingTableViewController: UITableViewController {
    
    // MARK: - IBOulet
    @IBOutlet weak var versionLB: UILabel!
    
    // MARK: - property
    private let appVersion = "CFBundleShortVersionString"
    private let performSegueID = "Login"
    let reference = Database.database().reference()
    
    // MARK: - IBAction
    // 카카오톡 로그아웃
    @IBAction func kakaotalkLogOut(_ sender: UISwitch) {
        switch sender.isOn {
        case false:
            KOSession.shared().logoutAndClose(completionHandler: { [weak self](success, error) in
                guard let `self` = self else { return }
                if error != nil{
                    return
                }else {
                    if success {
                        self.firebaseAuthlogOut()
                        self.performSegue(withIdentifier: self.performSegueID, sender: nil)

                    }else {
                        print("Failed to LogOut.")
                    }
                }
            })
        default:
            break
        }
    }
    // MARK: 페이스북 로그아웃
    @IBAction func facbookLogOut(_ sender: UISwitch) {
        let loginManager = LoginManager()
        switch sender.isOn {
        case false:
            loginManager.logOut()
            self.firebaseAuthlogOut()
        default:
            loginManager.logIn(readPermissions: [.email], viewController: self) { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success:
                    let accessToken = AccessToken.current
                    guard let accessTokenString = accessToken?.authenticationToken else { return }
                    let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                    Auth.auth().signIn(with: credentials, completion: { (user, error) in
                        if error == nil, user != nil{
                            let userEmail = user?.email ?? ""
                            let userDic = ["email" : userEmail]
                            self.reference.child("users").child(user!.uid).setValue(userDic)
                        }else{
                            if let errors = error {
                                print(errors.localizedDescription)
                                return
                            }
                            
                        }
                    })
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                default:
                    break
                }
            }
        }
    }
    // MARK: 파이어베이스 로그아웃
    @IBAction func firebaseLogOut(_ sender: UIButton) {
        UIAlertController.presentAlertController(target: self, title: "로그아웃", massage: "정말 로그아웃 하시겠습니까?", actionStyle: .destructive, cancelBtn: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.firebaseAuthlogOut()
            self.performSegue(withIdentifier: self.performSegueID, sender: nil)
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 앱버전 정보
        let versionText = Bundle.main.object(forInfoDictionaryKey: appVersion) as? String
        versionLB.text = versionText ?? "정보를 읽어 올 수 없습니다."
    }
    
}

// MARK: - Extension
extension SettingTableViewController {
    // MARK: Common FiebaseAuth Logout
    private func firebaseAuthlogOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch (let error) {
            print("error: \(error.localizedDescription)")
        }
    }
}
