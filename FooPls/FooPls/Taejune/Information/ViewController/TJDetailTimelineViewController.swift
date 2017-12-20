
import UIKit
import Firebase
import GooglePlacePicker

class TJDetailTimelineViewController: UIViewController, GMSPlacePickerViewControllerDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate, GooglePlaceDataDelegate {
    
    let autoSB = UIStoryboard(name: "SKMain", bundle: nil)
    var autoNavi: UINavigationController?
    var autoVC: SK_AutoSearchViewController?
    
    //MARK: - Firebase
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    
    //MARK: - Property
    var postingIndex: String = ""
    var date: String?
    var longitude: Double?
    var latitude: Double?
    var address: String?
    var selectedKey: String?
    var photoName: String?
    
    @IBOutlet weak var writeScrollView: UIScrollView!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailTitleTextField: UITextField!
    @IBOutlet weak var detailImgView: UIImageView!
    @IBOutlet weak var detailLocationTitleLabel: UILabel!
    @IBOutlet weak var detailLocationAddressLabel: UILabel!
    @IBOutlet weak var detailThoughtTextField: UITextField!
    @IBOutlet weak var detailContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        detailContentTextView.delegate = self
        writeScrollView.bounces = false
        //GooglePlacePicker에서 Data를 가져오기 위하여, 작업을 진행하여 준다.(Delegate구현부)
        autoNavi = autoSB.instantiateViewController(withIdentifier: "googlePlacePickerVC") as? UINavigationController
        autoVC = autoNavi?.visibleViewController as? SK_AutoSearchViewController
        autoVC?.delegate = self
        
        //플레이스 뷰를 내릴때 노티
        NotificationCenter.default.addObserver(forName: Notification.Name.newPosi,
                                               object: nil, queue: nil) {[weak self] (noti) in
                                                guard let `self` = self else { return }
                                                self.latitude = DataCenter.main.latitude
                                                self.longitude = DataCenter.main.longitude
                                                self.detailLocationTitleLabel.text = DataCenter.main.placeName
                                                self.detailLocationAddressLabel.text = DataCenter.main.placeAddress
                                                self.address = DataCenter.main.placeAddress
        }
    }
    
    private func loadData() {
        reference.child("users").child(userID!).child("calendar").child(selectedKey!).observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String: Any] {
                self.detailDateLabel.text = value["date"] as? String
                self.detailTitleTextField.text = value["title"] as? String
                let imgURL = value["imageurl"] as? String
                self.detailImgView.kf.setImage(with: URL(string: imgURL!))
                self.detailLocationTitleLabel.text = value["storename"] as? String
                self.detailLocationAddressLabel.text = value["storeaddress"] as? String
                self.detailContentTextView.text = value["content"] as? String
                self.detailThoughtTextField.text = value["thought"] as? String
                self.photoName = value["photoname"] as? String
                self.date = value["date"] as? String
                self.longitude = value["longitude"] as? Double
                self.latitude = value["latitude"] as? Double
                self.address = value["storeaddress"] as? String
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 글쓰기 버튼
    @IBAction func writeBtnAction(_ sender: UIButton) {
        
        //글의 제목이 없을 경우  알럿 창 띄움
        guard let contentTitle = detailTitleTextField.text else {
            UIAlertController.presentAlertController(target: self, title: "제목을 입력해주세요", massage: nil, actionStyle: .default, cancelBtn: false, completion: nil)
            return
        }
        //전번적인 내용들이 없을 경우 글쓰기가 안되게 설정
        guard let _ = detailImgView.image else { return }
        guard let locationTitle = detailLocationTitleLabel.text else { return }
        guard let contentTxtView = detailContentTextView.text else { return }
        guard let thought = detailThoughtTextField.text else { return }
        
        let alertSheet = UIAlertController(title: "등록", message: "이 글을 수정하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) { [weak self] (action) in
            guard let `self` = self else { return }
            guard let uploadImg = UIImageJPEGRepresentation(self.detailImgView.image!, 0.3) else { return }
            //사진이 만약 변경이 되었을 경우, 그리고 다른 내용은 바뀌고 사진은 안바뀌는 경우에도 사진을 덮어쓰기로 저장
            Storage.storage().reference().child("calendar_images").child(self.photoName!).putData(uploadImg, metadata: nil, completion: { [weak self] (metaData, error) in
                guard let `self` = self else { return }
                if error != nil {
                    print(error!.localizedDescription)
                }else {
                    //사진의 위치 주소값 저장
                    guard let photoID = metaData?.downloadURL()?.absoluteString else { return }
                    
                    let calendarDic = ["title": contentTitle,
                                       "nickname": self.userID!,
                                       "content": contentTxtView,
                                       "imageurl": photoID,
                                       "photoname": self.photoName!,
                                       "storename": locationTitle,
                                       "longitude": self.longitude!,
                                       "latitude": self.latitude!,
                                       "storeaddress": self.address!,
                                       "thought": thought,
                                       "date": self.date!,
                                       "timeStamp": ServerValue.timestamp()] as [String: Any]
                    // MARK: Noti
                    NotificationCenter.default.post(name: .reload, object: contentTitle)
                    self.reference.child("users").child(self.userID!).child("calendar").child(self.selectedKey!).updateChildValues(calendarDic)
                    //let key = self.reference.child("users").childByAutoId().key
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alertSheet.addAction(okAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
    
    @IBAction func detailImgBtnAction(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func detailLocationBtnAction(_ sender: UIButton) {
        //구글 PlacePicker와 연결함
        present(autoNavi!, animated: true, completion: nil)        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.detailImgView.image = photo
        self.dismiss(animated: true, completion: nil)
    }
    
    func positinData(lati: Double, longi: Double, address: String, placeName: String) {
        detailLocationTitleLabel.text = placeName
    }
    
    //MARK: - 장소를 선택했을 때 실행되는 메소드
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        self.longitude = place.coordinate.longitude
        self.latitude = place.coordinate.latitude
        self.detailLocationTitleLabel.text = place.name
        self.detailLocationAddressLabel.text = place.formattedAddress
        self.address = place.formattedAddress
    }
}

extension TJDetailTimelineViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요"
            textView.textColor = .lightGray
        }
    }
}
