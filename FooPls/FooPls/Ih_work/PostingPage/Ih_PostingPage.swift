
import UIKit
import GooglePlaces
import GoogleMaps
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class PostingPage: UIViewController,UINavigationControllerDelegate, ImagePickerDelegate,
GooglePlaceDataDelegate, UITextViewDelegate, UIImagePickerControllerDelegate {

    //MARK : - Variable
    
    
    var userInfo = Auth.auth().currentUser
    var lati : Double?
    var longi : Double?
    var timeStamp : String?
    var imageUrl : String?
    var photoName : String?
    
    @IBOutlet weak var postPageScrollView: UIScrollView!
    @IBOutlet weak var postDateLb: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var placeNameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nickNameLb: UILabel!
    @IBOutlet weak var postingDateLb: UILabel!
    @IBOutlet weak var thoughtsLb: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getDate()
        setUserInfo()
        hideKeyboardWhenTappedAround()
        contentTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(kyeboardAppear(_:)), name: .UIKeyboardWillShow , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.newPosi, object: nil, queue: nil) { (newPosi) in
            let latitu = DataCenter.main.latitude
            let longitu = DataCenter.main.longitude
            self.lati = latitu
            self.longi = longitu
            self.placeNameTF.text = DataCenter.main.placeName
            self.addressTF.text = DataCenter.main.placeAddress
        }

    }
    
    
    
    @IBAction func postingDone(_ sender : Any) {
        let time = ServerValue.timestamp()
        let timeStamp = String(describing: time)
        let nickName = DataCenter.main.currentUser?.nickName
        let imageinfo = DataCenter.main.imageInfo
        let url = imageinfo?.imageurl
        let photoname = imageinfo?.photoName
        let uid = DataCenter.main.currentUser?.uid
        
        guard let name = placeNameTF.text, let address = addressTF.text ,
            let content = contentTextView.text, let date = postingDateLb.text,
            let thoughts = thoughtsLb.text else {return}
        
      let postDic = ["storename" : name, "storeaddress" : address,
                       "content" : content, "latitude" : self.lati!, "longitude" : self.longi!,
                       "imageurl" : url!, "date" : date, "timeStamp" : timeStamp,
                       "photoname" : photoname!, "thoughts" : thoughts, "nickname" : nickName! ] as [String : Any]
            let AutoIDkey = Database.database().reference().childByAutoId().key
        Database.database().reference().child("users").child(uid!).child("posts").child(AutoIDkey).updateChildValues(postDic) { (error, ref) in
            if error != nil {
                print(error.debugDescription)
            }else {
                print("업로드성공")
            }
        }
        
//            DataCenter.main.postingUpload(uid : uid!, storeName: name, storeAddress: address, content: content, latitude: self.lati!, longitude: self.longi!, storeImgurl: url!, date: date, timeStamp: timeStamp, photoName: photoname!, thoughts: thoughts, nickname: nickName!)
       
        UIAlertController.presentAlertController(target: self, title: "업로드성공",
                                                 massage: "업로드 성공하였습니다.",
                                                 cancelBtn: false, completion: nil)
        print("업로드성공")
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
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
//        let imagePicker = ImagePickerVC(collectionViewLayout: UICollectionViewFlowLayout())
//        let navi = UINavigationController(rootViewController: imagePicker)
//        imagePicker.delegate = self
//        present(navi, animated: true, completion: nil)
//        print("DDDDDD")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.postImageView.image = photo
        self.dismiss(animated: true, completion: nil)
    }
    
    func photoSelected(_ seletedImges: UIImage) {
        postImageView.image = seletedImges
        DataCenter.main.uploadImgAndgetUrl(selectedImg: seletedImges)
    }
    
    func presentAutoSearch() {
        let autoSearch = UIStoryboard(name: "SKMain", bundle: nil)
        var navigationCon: UINavigationController?
        
        navigationCon = autoSearch.instantiateViewController(withIdentifier: "googlePlacePickerVC") as? UINavigationController
//        autoSearchVC?.delegate = self
        
        present(navigationCon!, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       contentTextView.text = ""
       contentTextView.textColor = .black
    }
    
    func positinData(lati: Double, longi: Double, address: String, placeName: String) {
        placeNameTF.text = placeName
        addressTF.text = address
        self.lati = lati
        self.longi = longi
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
    func setUserInfo() {
        self.nickNameLb.text = DataCenter.main.currentUser?.nickName
       
        
    }
    
    func setUI() {
        profileImgView.layer.cornerRadius = 25
        if let imgurl = DataCenter.main.profileImgUrl {
            let url = URL(string: imgurl)
            self.profileImgView.sd_setImage(with: url)
        }else {
            profileImgView.image = #imageLiteral(resourceName: "defaultProfile") //default image
        }
        
    }
    func getDate() {
        let getToday = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY년 MM월 DD일"
        let postingDate = dateFormat.string(from: getToday)
        self.postDateLb.text = postingDate
    }
}
