//
//  LoginAndSignUpView.swift
//  LogInSignUpProc

import UIKit

class LoginAndSignUpView: UIView {
    // MARK: View Layer
//    @IBOutlet weak var logInView: UIView?
    @IBOutlet weak var signUpView: UIView?
    @IBOutlet weak var loginStackView: UIStackView?
    
    // MARK: Button
    @IBOutlet weak var signUpBtn: UIButton?
    @IBOutlet weak var logInBtn: UIButton?
    
    // MARK: TextField
    @IBOutlet weak var emailTF: UITextField?
    @IBOutlet weak var passwordTF: UITextField?
    @IBOutlet weak var newEmailTF: UITextField?
    @IBOutlet weak var newPasswordTF: UITextField?
    @IBOutlet weak var rePasswordTF: UITextField?
    @IBOutlet weak var nickNameTF: UITextField?
    
    // MARK: Login + SignUp View Setting
    override func awakeFromNib() {
        
    }
    
    // MARK: Login + SignUp View Setting
    override func layoutSubviews() {
        super.layoutSubviews()
         // 스택뷰
        if let loginStackView = loginStackView?.arrangedSubviews{
            for view in loginStackView {
                (view as! UITextField).addUnderLine(height: 1, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            }
        }
        // 회원가입뷰
        if let subViews = signUpView?.subviews{
            for view in subViews[0 ... 2] {
               (view as! UITextField).addUnderLine(height: 1, color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            }
        }
    }
    
}
