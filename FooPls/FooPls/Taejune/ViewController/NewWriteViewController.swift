
import UIKit
import Firebase
import GooglePlacePicker

class NewWriteViewController: UIViewController, GMSPlacePickerViewControllerDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    //MARK: - Firebase
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    
    //MARK: - Property
    var selectedDate: String = ""
    var longitude: Double?
    var latitude: Double?
    var adress: String?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var contentTxtView: UITextView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = selectedDate
    }
    
    //MARK: - 뒤로 가기 버튼
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 글쓰기 버튼
    @IBAction func writeBtnAction(_ sender: UIButton) {
        guard let _ = contentImgView.image else {
            UIAlertController.presentAlertController(target: self, title: "알림", massage: "이미지를 선택해주세요.", cancelBtn: false, completion: nil)
            return
        }
        guard let locationTitle = locationTitle.text else {
            UIAlertController.presentAlertController(target: self, title: "알림", massage: "장소를 선택해주세요.", cancelBtn: false, completion: nil)
            return
        }
        guard let contentTxtView = contentTxtView.text else {
            UIAlertController.presentAlertController(target: self, title: "알림", massage: "내용을 입력해주세요.", cancelBtn: false, completion: nil)
            return
        }
        
        let alertSheet = UIAlertController(title: "등록", message: "이 글을 등록하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) { [unowned self] (action) in
            //rself.dismiss(animated: true, completion: nil)
            guard let uploadImg = UIImageJPEGRepresentation(self.contentImgView.image!, 0.3) else { return }
            Storage.storage().reference().child("calendar_images").child(self.userID!).putData(uploadImg, metadata: nil, completion: { [unowned self](metaData, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }else {
                    guard let photoID = metaData?.downloadURL()?.absoluteString else { return }
                    
                    let calendarDic = ["title": locationTitle, "content": contentTxtView, "photoID": photoID, "longitude": self.longitude!, "latitude": self.latitude!, "adress": self.adress!] as [String: Any]
                    self.reference.child("users").child(self.userID!).child("calendar").child(self.selectedDate).setValue(calendarDic)
                    
                    // MARK: Noti
                    NotificationCenter.default.post(name: .reload, object: locationTitle)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alertSheet.addAction(okAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
        
        //dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 장소 버튼을 누르면 GooglePlacePickerController로 들어감
    @IBAction func locationBtnAction(_ sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: 37.566627, longitude: 126.978432)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
        
        placePicker.navigationController?.navigationBar.barTintColor = UIColor.black
        placePicker.navigationController?.navigationBar.isTranslucent = false
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
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        self.longitude = place.coordinate.longitude
        self.latitude = place.coordinate.latitude
        self.locationTitle.text = place.name
        self.adress = place.formattedAddress
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        print("장소가 선택되지 않았습니다.")
        
    }
}

