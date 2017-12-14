//
//  Extension.swift

import UIKit

extension Notification.Name {
    static let reload = Notification.Name(rawValue: "reload")
}

extension UIViewController {
    // MARK: 탭으로 keyboard 내리기
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: UIView
extension UIView {
    
    // MARK: 뷰레이어
    func viewLayer(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        
    }
    // MARK: 코너
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    // MARK: 탭제스쳐
    func addTapGesture(tapNumber : Int, target: Any , action : Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
}

// MARK: UIAlertCotroller
extension UIAlertController {
    
    // MARK: 알림창
    static func presentAlertController(target: UIViewController,
                                       title: String?,
                                       massage: String?,
                                       actionStyle: UIAlertActionStyle = UIAlertActionStyle.default,
                                       cancelBtn: Bool,
                                       completion: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: actionStyle, handler: completion)
        alert.addAction(okAction)
        if cancelBtn {
            let cancelAction = UIAlertAction(title: "취소", style: actionStyle, handler: completion)
            alert.addAction(cancelAction)
        }
        target.present(alert, animated: true, completion: nil)
    }
}

