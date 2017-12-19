
import UIKit
import Firebase
import GooglePlacePicker

class NewWriteViewController: UIViewController, GMSPlacePickerViewControllerDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate, GooglePlaceDataDelegate {
    
    let autoSB = UIStoryboard(name: "SKMain", bundle: nil)
    var autoNavi: UINavigationController?
    var autoVC: SK_AutoSearchViewController?
    
    //MARK: - Firebase
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    
    weak var testDelegate: PopViewDelegate?
    
    //MARK: - Property
    var userNickname: String = ""
    var selectedDate: String = ""
    var longitude: Double?
    var latitude: Double?
    var address: String?
    var addressTitle:String = "가게 이름" {
        didSet {
            locationTitle.text = DataCenter.main.placeName
        }
    }
    
    @IBOutlet weak var writeScrollView: UIScrollView!
    @IBOutlet weak var customNaviBar: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTitle: UITextField!
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var LocationAddress: UILabel!
    @IBOutlet weak var contentTxtView: UITextView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = selectedDate
        writeScrollView.bounces = false
        //GooglePlacePicker에서 Data를 가져오기 위하여, 작업을 진행하여 준다.(Delegate구현부)
        autoNavi = autoSB.instantiateViewController(withIdentifier: "googlePlacePickerVC") as? UINavigationController
        autoVC = autoNavi?.visibleViewController as? SK_AutoSearchViewController
        autoVC?.delegate = self
        loadData()
        //플레이스 뷰를 내릴때 노티
        NotificationCenter.default.addObserver(forName: Notification.Name.newPosi,
                                               object: nil, queue: nil) {[weak self] (noti) in
                                                
                                                self?.latitude = DataCenter.main.latitude
                                                self?.longitude = DataCenter.main.longitude
                                                self?.locationTitle.text = DataCenter.main.placeName
                                                self?.LocationAddress.text = DataCenter.main.placeAddress
                                                self?.address = DataCenter.main.placeAddress
        }
    }
    
    private func loadData() {
        reference.child("users").child(userID!).child("profile").observeSingleEvent(of: .value) { [weak self](snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String: Any] {
                self.userNickname = value["nickname"] as! String
            }
            
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - 뒤로 가기 버튼
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 글쓰기 버튼
    @IBAction func writeBtnAction(_ sender: UIButton) {
        guard let contentTitle = contentTitle.text else {
            UIAlertController.presentAlertController(target: self, title: "제목을 입력해주세요", massage: nil, actionStyle: UIAlertActionStyle.default, cancelBtn: false, completion: nil)
            return
        }
        guard let _ = contentImgView.image else { return }
        guard let locationTitle = locationTitle.text else { return }
        guard let contentTxtView = contentTxtView.text else { return }
        guard let longitude = self.longitude, let latitude = self.latitude, let address = self.address else {
            UIAlertController.presentAlertController(target: self, title: "장소를 선택해주세요", massage: nil, actionStyle: UIAlertActionStyle.default, cancelBtn: false, completion: nil)
            return
        }
        
        UIAlertController.presentAlertController(target: self, title: "이 글을 등록하시겠습니까?", massage: "이 글을 등록하시겠습니까?", cancelBtn: true) { [weak self] (action) in
            guard let `self` = self else { return }
            guard let uploadImg = UIImageJPEGRepresentation(self.contentImgView.image!, 0.3) else { return }
            let uuid = UUID().uuidString
            Storage.storage().reference().child("calendar_images").child(uuid).putData(uploadImg, metadata: nil, completion: { [weak self] (metaData, error) in
                guard let `self` = self else { return }
                if error != nil {
                    print(error!.localizedDescription)
                }else {
                    guard let photoID = metaData?.downloadURL()?.absoluteString else { return }
                    
                    let calendarDic = ["title": contentTitle,
                                       "author": self.userNickname,
                                       "content": contentTxtView,
                                       "photoID": photoID,
                                       "photoName": uuid,
                                       "locationTitle": locationTitle,
                                       "longitude": longitude,
                                       "latitude": latitude,
                                       "address": address,
                                       "date": self.selectedDate,
                                       "postTime": ServerValue.timestamp()] as [String: Any]
                    
                    self.reference.child("users").child(self.userID!).child("calendar").childByAutoId().setValue(calendarDic)
                    
                    let key = self.reference.child("users").childByAutoId().key
                    
                    let alertSheet = UIAlertController(title: nil, message: "이 글을 포스팅하시겠습니까?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "예", style: .default, handler: { [weak self] (action) in
                        guard let `self` = self else { return }
                        let postDic = ["title": contentTitle,
                                       "author": self.userNickname,
                                       "content": contentTxtView,
                                       "imageurl": photoID,
                                       "photoName": uuid,
                                       "storename": locationTitle,
                                       "longitude": longitude,
                                       "latitude": latitude,
                                       "storeaddress": address,
                                       "date": self.selectedDate,
                                       "postTime": ServerValue.timestamp()] as [String: Any]
                        self.reference.child("users").child(self.userID!).child("posts").child(key).updateChildValues(postDic)
                        self.dismiss(animated: true, completion: nil)
                    })
                    let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: { [weak self] (action) in
                        guard let `self` = self else { return }
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertSheet.addAction(okAction)
                    alertSheet.addAction(cancelAction)
                    self.present(alertSheet, animated: true, completion: nil)
                    
                    
                    
                    
                    
                    
//                    UIAlertController.presentAlertController(target: self, title: nil, massage: "이 글을 포스팅하시겠습니까?", cancelBtn: true, completion: { [weak self] (action) in
//                        guard let `self` = self else { return }
//
//                        let postDic = ["title": contentTitle,
//                                           "author": self.userNickname,
//                                           "content": contentTxtView,
//                                           "photoID": photoID,
//                                           "photoName": uuid,
//                                           "locationTitle": locationTitle,
//                                           "longitude": longitude,
//                                           "latitude": latitude,
//                                           "address": address,
//                                           "date": self.selectedDate,
//                                           "postTime": ServerValue.timestamp()] as [String: Any]
//                        self.reference.child("users").child(self.userID!).child("posts").child(key).setValue(postDic)
//                    })
                }
            })
        }
//        dismiss(animated: true, completion: nil)
//        let alertSheet = UIAlertController(title: "등록", message: "이 글을 등록하시겠습니까?", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "네", style: .default) { [weak self] (action) in
//            guard let `self` = self else { return }
//            guard let uploadImg = UIImageJPEGRepresentation(self.contentImgView.image!, 0.3) else { return }
//            let uuid = UUID().uuidString
//            Storage.storage().reference().child("calendar_images").child(uuid).putData(uploadImg, metadata: nil, completion: { [weak self] (metaData, error) in
//                guard let `self` = self else { return }
//                if error != nil {
//                    print(error!.localizedDescription)
//                }else {
//                    guard let photoID = metaData?.downloadURL()?.absoluteString else { return }
//
//                    let calendarDic = ["title": contentTitle,
//                                       "author": self.userNickname,
//                                       "content": contentTxtView,
//                                       "photoID": photoID,
//                                       "photoName": uuid,
//                                       "locationTitle": locationTitle,
//                                       "longitude": longitude,
//                                       "latitude": latitude,
//                                       "address": address,
//                                       "date": self.selectedDate,
//                                       "postTime": ServerValue.timestamp()] as [String: Any]
//
//                    self.reference.child("users").child(self.userID!).child("calendar").childByAutoId().setValue(calendarDic)
//
//                    let key = self.reference.child("users").childByAutoId().key
//
//
//                }
//            })
//        }

//        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
//        alertSheet.addAction(okAction)
//        alertSheet.addAction(cancelAction)
//        present(alertSheet, animated: true, completion: nil)
    }
    

    //MARK: - 장소 버튼을 누르면 GooglePlacePickerController로 들어감
    @IBAction func locationBtnAction(_ sender: UIButton) {
        //구글 PlacePicker와 연결함

        present(autoNavi!, animated: true, completion: nil)
    }
    
    
    //MARK: - GooglePickerView에 있는 값을 Delegate값으로 가져옴
    func positinData(lati: Double, longi: Double, address: String, placeName: String) {

        print(address)
        locationTitle.text = placeName
        LocationAddress.text = address
        longitude = longi
        latitude = lati
        self.address = address
        
        func positionDataLoad() {
         self.latitude = DataCenter.main.latitude
         self.longitude = DataCenter.main.longitude
         locationTitle.text = DataCenter.main.placeName
         LocationAddress.text = DataCenter.main.placeAddress
        }
        
        

//        let storyboard = UIStoryboard(name: "SKMain", bundle: nil)
//        if let googlePicekerVC = storyboard.instantiateViewController(withIdentifier: "googlePlacePickerVC") as? UINavigationController {
//            present(googlePicekerVC, animated: true, completion: nil)
//        }




    }
    
    //MARK: - 장소를 선택했을 때 실행되는 메소드
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        self.longitude = place.coordinate.longitude
        self.latitude = place.coordinate.latitude
        self.locationTitle.text = place.name
        self.LocationAddress.text = place.formattedAddress
        self.address = place.formattedAddress
    }
    
    @IBAction func photoSelectAction(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.contentImgView.image = photo
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 장소를 선택하지 않았을 때 실행하는 메소드
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

