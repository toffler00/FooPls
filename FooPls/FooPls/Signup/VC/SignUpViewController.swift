
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
                    let userNickname = user?.displayName ?? ""
                    let defaultProfile = UIImage(named: "defaultProfile")
                    let uploadImg = UIImageJPEGRepresentation(defaultProfile!, 0.3)
                    Storage.storage().reference().putData(uploadImg!, metadata: nil, completion: { [weak self] (metadata, error) in
                        guard let `self` = self else { return }
                        if error != nil {
                            print(error!.localizedDescription)
                        }else {
                            guard let profilePhotoID = metadata?.downloadURL()?.absoluteString else { return }
                            let userDictionary : [String: Any] = ["email": email, "nickname": userNickname, "phone" : "", "profilePhotoID": profilePhotoID]
                            self.reference.child("users").child(user!.uid).setValue(userDictionary)
                            UIAlertController.presentAlertController(target: self,
                                                                     title: "가입축하",
                                                                     massage: "가입을 축하드립니다.",
                                                                     actionStyle: .default,
                                                                     cancelBtn: false,
                                                                     completion: { _ in
                                                                        self.performSegue(withIdentifier: "mainSegue", sender: nil)
                            })
                        }
                    })
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


