//
//  SK_SpecificTableViewController.swift
//  FooPls
//
//  Created by Samuel K on 2018. 1. 10..
//  Copyright © 2018년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import Firebase
import GooglePlacePicker
import PKHUD

class SK_SpecificTableViewController: UIViewController, UINavigationControllerDelegate , UIImagePickerControllerDelegate  {

    let autoSB = UIStoryboard(name: "SKMain", bundle: nil)
    var autoNavi: UINavigationController?
    var autoVC: SK_AutoSearchViewController?
    
    //MARK: - Firebase
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    
    //MARK: - Property
    var postingIndex: String = ""
    var date: String?
    var address:String?
    var comment:String?
    var thought:String?
    var detailImage:UIImage?
    
//    var longitude: Double?
//    var latitude: Double?

//    var selectedKey: String?
//    var photoName: String?
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var writeScrollView: UIScrollView!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailTitleTextField: UITextField!
    @IBOutlet weak var detailImgView: UIImageView!
    @IBOutlet weak var detailLocationTitleLabel: UILabel!
    @IBOutlet weak var detailLocationAddressLabel: UILabel!
    @IBOutlet weak var detailThoughtTextField: UITextField!
    @IBOutlet weak var detailContentTextView: UITextView!
    
    //MARK: - Life Cycel
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.allowsInteraction = false
        HUD.dimsBackground = false
        writeScrollView.bounces = false
        
        
        detailDateLabel.text = date
        detailTitleTextField.text = postingIndex
        detailLocationAddressLabel.text = address
        detailLocationTitleLabel.text = postingIndex
        detailImgView.image = detailImage
        detailContentTextView.text = comment
        detailThoughtTextField.text = thought
        
        
        
        
        //플레이스 뷰를 내릴때 노티
//        NotificationCenter.default.addObserver(forName: Notification.Name.newPosi,
//                                               object: nil, queue: nil) {[weak self] (noti) in
//                                                guard let `self` = self else { return }
//                                                self.latitude = DataCenter.main.latitude
//                                                self.longitude = DataCenter.main.longitude
//                                                self.detailLocationTitleLabel.text = DataCenter.main.placeName
//                                                self.detailLocationAddressLabel.text = DataCenter.main.placeAddress
//                                                self.address = DataCenter.main.placeAddress
//        }
//        //노티센터를 통해 키보드가 올라오고 내려갈 경우 실행할 함수 설정
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - 키보드가 올라올 경우 키보드의 높이 만큼 스크롤 뷰의 크기를 줄여줌
    @objc func keyboardDidShow(_ noti: Notification) {
        guard let info = noti.userInfo else { return }
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        writeScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    //MARK: - 키보드가 내려갈 경우 원래의 크기대로 돌림
    @objc func keyboardWillHide(_ noti: Notification) {
        writeScrollView.contentInset = UIEdgeInsets.zero
    }
    
    
    //MARK: - IBAction
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

////MARK: - Extension
//extension SK_SpecificTableViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = .black
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "내용을 입력해주세요"
//            textView.textColor = .lightGray
//        }
//    }
//}

