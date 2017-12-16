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

class SettingTableViewController: UITableViewController {
    
    // MARK: IBAction
    // 카카오톡 로그아웃
    @IBAction func kakaotalkLogOut(_ sender: UISwitch) {
        if sender.isOn == false {
            KOSession.shared().logoutAndClose(completionHandler: { [weak self](success, error) in
                guard let `self` = self else { return }
                if error != nil{
                    return
                }else {
                    if success {
                        self.firebaseAuthlogOut()
                    }else {
                        print("Failed to LogOut.")
                    }
                }
            })
        }
    }
    // 페이스북 로그아웃
    @IBAction func facbookLogOut(_ sender: UISwitch) {
        switch sender.isOn {
        case false:
            let loginManager = LoginManager()
            loginManager.logOut()
            self.firebaseAuthlogOut()
        default:
            break
        }
    }
    // 파이어베이스 로그아웃
    @IBAction func firebaseLogOut(_ sender: UIButton) {
        UIAlertController.presentAlertController(target: self, title: "로그아웃", massage: "정말 로그아웃 하시겠습니까?", actionStyle: .destructive, cancelBtn: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.firebaseAuthlogOut()
        }
    }
    
    // MARK: IBOulet
    @IBOutlet weak var versionLB: UILabel!
    
    // MARK: property
    let appVersion = "CFBundleShortVersionString"
    let performSegueID = "Login"
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Common FiebaseAuth Logout
    func firebaseAuthlogOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: self.performSegueID, sender: nil)
        } catch (let error) {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 앱버전 정보
        let versionText = Bundle.main.object(forInfoDictionaryKey: appVersion) as? String
        versionLB.text = versionText ?? "정보를 읽어 올 수 없습니다."
    }
    
}
