//
//  SettingTableViewController.swift
//  FooPls

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
    private let loginSegueID = "GoToLogin"
    let reference = Database.database().reference()
    
    // MARK: - IBAction
    // 설정창 닫기
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 로그아웃
    @IBAction func firebaseLogOut(_ sender: UIButton) {
        UIAlertController.presentAlertController(target: self, title: "로그아웃", massage: "정말 로그아웃 하시겠습니까?", actionStyle: .destructive, cancelBtn: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.firebaseLogOut()
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showAppVersion()
    }
    
}

// MARK: - Extension
extension SettingTableViewController {
    // MARK: Fiebase Logout
    private func firebaseLogOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: self.loginSegueID, sender: nil)
        } catch (let error) {
            print("error: \(error.localizedDescription)")
        }
    }
    // MARK: app version
    private func showAppVersion() {
        let versionText = Bundle.main.object(forInfoDictionaryKey: appVersion) as? String
        versionLB.text = versionText ?? "정보를 읽어 올 수 없습니다."
    }
    
    func logout() {
        
    }
}
