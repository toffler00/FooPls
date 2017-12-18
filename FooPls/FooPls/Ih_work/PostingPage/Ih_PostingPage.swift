
import UIKit
import GooglePlaces
import GoogleMaps
import Photos
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PostingPage: UIViewController,UINavigationControllerDelegate, ImagePickerDelegate,
GooglePlaceDataDelegate {
 
    
    var dataCenter : DataCenter!
    var userInfo = Auth.auth().currentUser
    
    @IBOutlet weak var postPageScrollView: UIScrollView!
    
    @IBOutlet weak var postDataLb: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var placeNameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nickNameLb: UILabel!
    @IBOutlet weak var postingDateLb: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        hideKeyboardWhenTappedAround()

        NotificationCenter.default.addObserver(self, selector: #selector(kyeboardAppear(_:)), name: .UIKeyboardWillShow , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: .UIKeyboardWillHide, object: nil)

    }
    
    @IBAction func handleDone(_ sender: Any) {
        guard let uid = userInfo?.uid else {return}
        guard let name = placeNameTF.text, let adress = addressTF.text, let content = contentTextView.text,
            let image = postImageView.image, let date = postingDateLb.text else {return}
        let img = UIImageJPEGRepresentation(image, 0.5)
        let autoID = NSUUID().uuidString
        Storage.storage().reference().child(uid).child(autoID).putData(img!, metadata: nil)
        { (metadata, error) in
            guard let imgUrl = metadata?.downloadURL()?.absoluteString
                else {return}
            let dic = ["storename" : name,
                       "storeaddress" : adress,
                       "content" : content,
                       "imageurl" : imgUrl,
                       "date" : date] as [String : Any]
            Database.database().reference().child("users").child(uid).child("posts")
                .childByAutoId().updateChildValues(dic) { (error, ref) in
                    if error != nil {
                        print(error.debugDescription)
                    }else {
                    UIAlertController.presentAlertController(target: self, title: "업로드성공",
                                                             massage: "업로드 성공하였습니다.",
                                                             cancelBtn: false, completion: nil)
                    print("업로드성공")
                    }
            }
        }
    }
    

    @IBAction func searchPlace(_ sender: Any) {
           presentAutoSearch()
    }
    
    @IBAction func imagePick(_ sender: UIButton) {
        let imagePicker = ImagePickerVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navi = UINavigationController(rootViewController: imagePicker)
        imagePicker.delegate = self
        present(navi, animated: true, completion: nil)
        print("DDDDDD")
    }
    
    func presentAutoSearch() {
        let autoSearch = UIStoryboard(name: "SKMain", bundle: nil)
        var navigationCon: UINavigationController?
        var autoSearchVC : SK_AutoSearchViewController?
        
        navigationCon = autoSearch.instantiateViewController(withIdentifier: "googlePlacePickerVC") as? UINavigationController
        autoSearchVC = navigationCon?.visibleViewController as? SK_AutoSearchViewController
        autoSearchVC?.delegate = self
        
        present(navigationCon!, animated: true, completion: nil)
    }
    
    
    func positinData(lati: Double, longi: Double, address: String, placeName: String) {
        placeNameTF.text = placeName
        addressTF.text = address
    }
    
    func photoSelected(_ seletedImges: UIImage) {
        postImageView.image = seletedImges
    }
    
    //MARK: - 키보드가 올라올 경우 키보드의 높이 만큼 스크롤 뷰의 크기를 줄여줌
    @objc func kyeboardAppear(_ noti: Notification) {
        guard let info = noti.userInfo else { return }
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        postPageScrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.height)
    }
    
    //MARK: - 키보드가 내려갈 경우 원래의 크기대로 돌림
    @objc func keyboardDisappear(_ noti: Notification) {
        postPageScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension PostingPage {
    func setUI() {
        profileImgView.layer.cornerRadius = 25
        profileImgView.image = #imageLiteral(resourceName: "defaultProfile") //default image
    }

}
