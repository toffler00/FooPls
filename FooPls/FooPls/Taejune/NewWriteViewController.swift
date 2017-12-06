
import UIKit
import Firebase
import GooglePlacePicker

class NewWriteViewController: UIViewController, GMSPlacePickerViewControllerDelegate, UINavigationControllerDelegate {
    
    
    
    //MARK: - Firebase
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    
    //MARK: - Property
    var selectedDate: String = ""
    var longitude: Double?
    var latitude: Double?
    var meno: String?
    //var locationTitle: String?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var contentTxtView: UITextView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - 뒤로 가기 버튼
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 글쓰기 버튼
    @IBAction func writeBtnAction(_ sender: UIButton) {
        let contentsDic = ["title": "해월집", "image": "imageURL", "content": "가까워요"]
        reference.child("users").child(userID!).child("calendar").child(selectedDate).setValue(contentsDic)
        dismiss(animated: true, completion: nil)
//        let alersheet = UIAlertController(title: "등록", message: "이 글을 등록하시겠습니까?", preferredStyle: .alert)
        
    }
    @IBAction func locationBtnAction(_ sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: 37.566627, longitude: 126.978432)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
        
        placePicker.navigationController?.delegate = self
        placePicker.navigationController?.navigationBar.barTintColor = UIColor.yellow
        placePicker.navigationController?.navigationBar.backgroundColor = UIColor.yellow
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        self.meno = place.name
        self.longitude = place.coordinate.longitude
        self.latitude = place.coordinate.latitude
        self.locationTitle.text = place.name
 
        print("장소명 : ", place.name)
        print("주소명 : ", place.formattedAddress)
        print("어트리뷰션 : ", place.attributions)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        print("장소가 선택되지 않았습니다.")
        
    }
}
