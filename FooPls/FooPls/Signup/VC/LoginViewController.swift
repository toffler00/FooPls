// LoginViewController
import UIKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

let userAccount = "account"

class LoginViewController: UIViewController {
    
    // MARK: 프로퍼티
   
    
    // @IBOutlet
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var kakaoBtn: KOLoginButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var faceBookBtn: FBSDKLoginButton!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius  = loginBtn.frame.size.height / 2
        facebookBtn.layer.cornerRadius  = facebookBtn.frame.size.height / 2
        kakaoBtn.layer.cornerRadius  = kakaoBtn.frame.size.height / 2
        faceBookBtn.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil
        )
    }
    
    @objc func keyboardDidShow(_ noti: Notification) {
        guard let info = noti.userInfo else { return }
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        loginScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    @objc func keyboardWillHide(_ noti: Notification) {
        loginScrollView.contentInset = UIEdgeInsets.zero
    }
    
    // MARK: IBAction
    //MARK: - 카카오 버튼 눌렀을 때
    @IBAction func kakaoBtnAction(_ sender: UIButton) {
        //유효 토큰 제거
        KOSession.shared().close()
        //
        KOSession.shared().presentingViewController = self.navigationController
        KOSession.shared().open { (error) in
            KOSession.shared().presentingViewController = nil
            if KOSession.shared().isOpen() {
                self.requestFirebaseCustomToken(accessToken: KOSession.shared().accessToken)
            } else {
                print("login failed: \(error!)")
            }
        }
    }
    
//    @IBAction func facebookBtnAction(_sender: UIButton) {
//
//    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty else {
            UIAlertController.presentAlertController(target: self,
                                                     title: "이메일을 입력해 주세요.",
                                                     massage: nil,
                                                     actionStyle: .default,
                                                     cancelBtn: false,
                                                     completion: nil)
            return
        }
        guard let pwd = pwdTF.text, !pwd.isEmpty else {
            UIAlertController.presentAlertController(target: self,
                                                     title: "비밀번호를 입력해 주세요.",
                                                     massage: nil,
                                                     actionStyle: .default,
                                                     cancelBtn: false,
                                                     completion: nil)
            return
        }
        Auth.auth().signIn(withEmail: email, password: pwd) { [weak self] (user, error) in
            guard let `self` = self else { return }
            if error == nil, user != nil{
                let account = Account(email: email, password: pwd)
                do{
                    let data = try JSONEncoder().encode(account)
                    KeychainWrapper.standard.set(data, forKey: userAccount)
                    self.performSegue(withIdentifier: "mainSegue", sender: nil)
                }catch (let error){
                    print("\(error.localizedDescription)")
                }
            }else{
                UIAlertController.presentAlertController(target: self,
                                                         title: "이메일 또는 비밀번호가\n 잘못되었습니다.",
                                                         massage: nil,
                                                         actionStyle: .default,
                                                         cancelBtn: false,
                                                         completion: nil)
            }
        }
    }
    
    //MARK: - 커스텀 토큰을 만들기위해 만든 서버에 POST를 보내서 파이어베이스에 맞는 커스텀 토큰을 가져옴
    func requestFirebaseCustomToken(accessToken: String) {
        //VALIDATION SERVER는 로컬 서버
        let url = URL(string: String(format: "%@/verifyToken", Bundle.main.object(forInfoDictionaryKey: "VALIDATION_SERVER_URL") as! String))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        //카카오에서 받아오 토큰을 저장
        let token = KOSession.shared().accessToken!
        //토큰을 딕셔너리로 만들어서 json 파라미터로 만듬, 그리고 그 파라미터를 RequestBody에 넣음
        let parameters: [String: String] = ["token": token]
        do {
            let jsonParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = jsonParams
        } catch {
            print("Error in adding token as a parameter: \(error)")
        }
        //Request를 만들면 Session을 통해 POST를 보냄
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error in request token verifying: \(error!)")
                return
            }
            do {
                //포스트를 통해 받은 데이터를 json으로 만들고 그 json의 파라미터인 "firebase_Token" (이 값은 파이어베이스의 커스텀 토큰값)을 불러와서 커스텀 토큰으로 로그인하는 파이어베이스 인증 메소드를 사용하여 로그인
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                let firebaseToken = jsonResponse["firebase_token"]!
                self.signInToFirebaseWithToken(firebaseToken: firebaseToken)
            } catch let error {
                print("Error in parsing token: \(error)")
            }
            
            }.resume()
    }
    
    //MARK: - 파이어베이스 토큰을 통한 로그인
    func signInToFirebaseWithToken(firebaseToken: String) {
        Auth.auth().signIn(withCustomToken: firebaseToken) { (user, error) in
            if let authError = error {
                print("authError",authError)
            } else {
                self.performSegue(withIdentifier: "mainSegue", sender: self)
            }
        }
    }
}

// MARK: FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error!) {
        if result?.token == nil {
            return
        }else{
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { [weak self] (user, error) in
                guard let `self` = self else { return }
                if error == nil, user != nil {
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                }
            }
        }
 
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
}
