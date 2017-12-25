
import UIKit
import Firebase

class TJModifyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Property
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    let mainColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    
    //MARK: - IBOutlet
    @IBOutlet weak var profileBGImgView: UIImageView!
    @IBOutlet weak var modifyScrollView: UIScrollView!
    @IBOutlet weak var profilePhotoView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //노티센터를 통해 키보드가 올라오고 내려갈 경우 실행할 함수 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //MARK: - 키보드가 올라올 경우 키보드의 높이 만큼 스크롤 뷰의 크기를 줄여줌
    @objc func keyboardDidShow(_ noti: Notification) {
        guard let info = noti.userInfo else { return }
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        modifyScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    //MARK: - 키보드가 내려갈 경우 원래의 크기대로 돌림
    @objc func keyboardWillHide(_ noti: Notification) {
        modifyScrollView.contentInset = UIEdgeInsets.zero
    }
    
    //MARK: - Method
    private func setupUI() {
        profilePhotoView.layer.borderColor = mainColor.cgColor
        profilePhotoView.layer.borderWidth = 3
        profilePhotoView.layer.cornerRadius = (profilePhotoView.frame.width / 2) - 3
    }
    
    private func loadData() {
        reference.child("users").child(userID!).child("profile").observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String : Any] {
                //데이터를 받아서 값이 비어 있다면 nil값을 넣음
                var nickname = value["nickname"] as? String
                var email = value["email"] as? String
                var phone = value["phone"] as? String
                if nickname == "" {
                    nickname = nil
                }else if email == "" {
                    email = nil
                }else if phone == "" {
                    phone = nil
                }
                let profileImg = value["photoID"] as? String
                self.profileImgView.kf.setImage(with: URL(string: profileImg!))
                self.profileBGImgView.kf.setImage(with: URL(string: profileImg!))
                self.nicknameTextField.text = nickname
                self.emailTextField.text = email
                self.phoneTextField.text = phone
            }
        }
    }
    
    //MARK: - ButtonAction
    //프로필 버튼을 눌렀을 때 사진 선택하는 뷰 컨트롤러로 이동
    @IBAction func profilePhotoBtnAction(_ sender: UIButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    //백 버튼 눌렀을 때 pop 시킴
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //수정 버튼을 눌렀을 때
    @IBAction func modifyBtnAction(_ sender: CustomButton) {
        UIAlertController.presentAlertController(target: self, title: "수정하시겠습니까?", massage: nil, cancelBtn: true) { [weak self] (action) in
            guard let `self` = self else { return }
            //텍스트 필드에 입력된 값이 없을 경우 빈 문자열로 저장
            let nickname = self.nicknameTextField.text ?? ""
            let email = self.emailTextField.text ?? ""
            let phone = self.phoneTextField.text ?? ""
            let profileDic = ["nickname": nickname, "email": email, "phone": phone]
            //수정된 값을 저장
            self.reference.child("users").child(self.userID!).child("profile").updateChildValues(profileDic)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - ImgPickerView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {

            profileImgView.image = img
            profileBGImgView.image = img
            guard let uploadData = UIImageJPEGRepresentation(img, 0.3) else { return }
            // Save imageData
            Storage.storage().reference().child("profile_images").child(userID!).putData(uploadData, metadata: nil, completion: { [weak self] (metadata, error) in
                guard let `self` = self else { return }
                guard let photoID = metadata?.downloadURL()?.absoluteString else { return }
                self.reference.child("users").child(self.userID!).child("profile").updateChildValues(["photoID": photoID], withCompletionBlock: { (error, databaseRef) in
                })
            })
        }
        dismiss(animated: true, completion: nil)
    }
}
