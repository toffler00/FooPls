
// SignUpVC
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var signupScrollView: UIScrollView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var rePwdTF: UITextField! {
        didSet{
            rePwdTF.delegate = self
        }
    }
    
    // MARK: Property
    lazy var reference = Database.database().reference()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signupScrollView.bounces = false
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ noti: Notification) {
        guard let info = noti.userInfo else { return }
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        signupScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    @objc func keyboardWillHide(_ noti: Notification) {
        signupScrollView.contentInset = UIEdgeInsets.zero
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func singUpBtn(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty else{
            UIAlertController.presentAlertController(target: self,
                                                     title: "이메일을 입력해주세요,",
                                                     massage: nil,
                                                     cancelBtn: false,
                                                     completion: nil)
            return
        }
        guard let pwd = pwdTF.text, !pwd.isEmpty else{
            UIAlertController.presentAlertController(target: self,
                                                     title: "비밀번호를 입력해주세요.",
                                                     massage: nil,
                                                     cancelBtn: false,
                                                     completion: nil)
            return
        }
        guard let rePwd = rePwdTF.text, !rePwd.isEmpty else{
            UIAlertController.presentAlertController(target: self,
                                                     title: "비밀번호를 다시 입력해주세요.",
                                                     massage: nil,
                                                     cancelBtn: false,
                                                     completion: nil)
            return
        }
        
        if pwd != rePwd {
            UIAlertController.presentAlertController(target: self,
                                                     title: "비밀번호가 다릅니다.",
                                                     massage: nil,
                                                     cancelBtn: false,
                                                     completion: nil)
        }else{
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { [weak self] (user, error) in
                guard let `self` = self else { return }
                if error == nil && user != nil {
                    let userNickname = user?.displayName ?? user?.email
                    let defaultProfileURL = "https://firebasestorage.googleapis.com/v0/b/foopls-84f76.appspot.com/o/profile_images%2FdefaultProfile.png?alt=media&token=7bca209f-50c9-4b5f-91ed-b651ded3b57f"
                    let userDictionary : [String: Any] = ["email": email, "nickname": userNickname!, "phone" : "", "photoID": defaultProfileURL]
                    self.reference.child("users").child(user!.uid).child("profile").setValue(userDictionary)
                    UIAlertController.presentAlertController(target: self,
                                                             title: "가입축하",
                                                             massage: "가입을 축하드립니다.",
                                                             actionStyle: .default,
                                                             cancelBtn: false,
                                                             completion: { _ in
                                                                self.performSegue(withIdentifier: "mainSegue", sender: nil)
                    })
                }else {
                    let firebaseErrorMsg = error!.localizedDescription
                    let errorMsg = firebaseError(rawValue: firebaseErrorMsg)?.errorStr
                    
                    UIAlertController.presentAlertController(target: self,
                                                             title: "경고", massage: errorMsg, cancelBtn: false, completion: nil)
                }
            })
        }
    }
}

// MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    // MARK: textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rePwdTF.resignFirstResponder()
        return true
    }
}

//MARK: - Enum
//파이어베이스 가입시 발생하는 에러에 대한 한국어 처리
enum firebaseError : String{
    case alreadyEmail = "The email address is already in use by another account."
    case badlyFormatEmail = "The email address is badly formatted."
    case passwordError = "The password must be 6 characters long or more."
    
    var errorStr: String {
        switch self {
        case .alreadyEmail:
            return "이미 존재하는 메일입니다."
        case .badlyFormatEmail:
            return "잘못된 이메일 형식입니다."
        case .passwordError:
            return "비밀번호가 너무 짧습니다."
        }
    }
}


