
import UIKit
import GooglePlaces
import GoogleMaps
import Photos
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PostVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, ImagePickerDelegate, GooglePlaceDataDelegate {
    
    
    //MARK: - UI
    var postPageScrollView : UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    var addImageBtn : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(selectImg(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var contentTextview : UITextView = {
        let contentTextV = UITextView()
        return contentTextV
    }()
    
    var contentIntroLb : UILabel = {
        let content = UILabel()
        return content
    }()
    
    var googlePlaceBtn : UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var storeNameTF : UITextField = {
        let nameTF = UITextField()
        return nameTF
    }()
    
    
    var storeAdressLb : UILabel = {
        let adressLb = UILabel()
        return adressLb
    }()
    
    var adressLb : UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    var toSearchBtn : UIButton = {
        let sbtn = UIButton()
        sbtn.addTarget(self, action: #selector(presentGplace), for: .touchUpInside)
        return sbtn
    }()
    
    var postDoneBtn : UIButton = {
        let done = UIButton()
        done.addTarget(self, action: #selector(handlerDone), for: .touchUpInside)
        return done
    }()
    
    var backToMainBtn : UIButton = {
        let back = UIButton()
        back.addTarget(self, action: #selector(handlerBack), for: .touchUpInside)
        return back
    }()

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var postHeader: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet var postImgView: UIImageView!
    @IBOutlet weak var placeBackView: UIView!
    @IBOutlet weak var storeNameBackView: UIView!
    @IBOutlet weak var contentBackView: UIView!
    
    //MARK : - variable
    var dataCenter : DataCenter!
    var userInfo = Auth.auth().currentUser
    
    


    
    //MARK : rifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(kyeboardAppear(_:)), name: .UIKeyboardWillShow , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: .UIKeyboardDidHide, object: nil)
       
    }
    
    // MARK: - show Photolibrary
    @objc func selectImg(sender: UIButton) {
        //imgpicker
        let imagePicker = ImagePickerVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navi = UINavigationController(rootViewController: imagePicker)
        imagePicker.delegate = self
        present(navi, animated: true, completion: nil)
        print("DDDDDD")
    }
    
    @objc func presentGplace() {
        presentAutoSearch()
    
    }
    
    func positinData(lati: Double, longi: Double, address: String, placeName: String) {
       storeNameTF.text = placeName
       adressLb.text = address
    }
    
    // MARK: image pick Delegate
    func photoSelected(_ seletedImges: UIImage) {
        postImgView.image = seletedImges
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image =  info[UIImagePickerControllerOriginalImage]
            as? UIImage
        {
             self.postImgView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Post upload
    @objc func handlerDone() {
        guard let uid = userInfo?.uid else {return}
        guard let name = storeNameTF.text, let adress = adressLb.text, let content = contentTextview.text,
            let image = postImgView.image else {return}
        let img = UIImageJPEGRepresentation(image, 0.5)
        let autoID = NSUUID().uuidString
        Storage.storage().reference().child(uid).child(autoID).putData(img!, metadata: nil)
        { (metadata, error) in
            guard let imgUrl = metadata?.downloadURL()?.absoluteString
                else {return}
            let dic = ["storename" : name,
                       "storeaddress" : adress,
                       "content" : content,
                       "imageurl" : imgUrl] as [String : Any]
            Database.database().reference().child("users").child(uid).child("posts")
                .childByAutoId().updateChildValues(dic) { (error, ref) in
                    if error != nil {
                        print(error.debugDescription)
                    }else {
                        print("업로드성공")
                    }
            }
        }
    
    }
    func toProfilePage() {
        
    }
    
    @objc func handlerBack() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension PostVC {
    func presentAutoSearch() {
        let autoSearch = UIStoryboard(name: "SKMain", bundle: nil)
        var navigationCon: UINavigationController?
        var autoSearchVC : SK_AutoSearchViewController?
        
        navigationCon = autoSearch.instantiateViewController(withIdentifier: "googlePlacePickerVC") as? UINavigationController
        autoSearchVC = navigationCon?.visibleViewController as? SK_AutoSearchViewController
        autoSearchVC?.delegate = self
        
        present(navigationCon!, animated: true, completion: nil)
    }
    

    
    //MARK: - 키보드가 올라올 경우 키보드의 높이 만큼 스크롤 뷰의 크기를 줄여줌
    @objc func kyeboardAppear(_ noti: Notification) {
        guard let info = noti.userInfo else { return }
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
//        postPageScrollView.frame = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        postPageScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                          height: (self.view.frame.height) + keyboardFrame.height)
    }
    
    //MARK: - 키보드가 내려갈 경우 원래의 크기대로 돌림
    @objc func keyboardDisappear(_ noti: Notification) {
        postPageScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                          height: self.view.frame.height)
    }

    func setUI() {
        
        self.view.addSubview(postPageScrollView)
        postPageScrollView.frame = CGRect(x: 0, y: 0,
                                        width: self.view.frame.width,
                                        height: self.view.frame.height)
        
        postPageScrollView.addSubview(backgroundView)
        backgroundView.bounds = CGRect(x: 0, y: 0, width: postPageScrollView.frame.width,
                                       height: postPageScrollView.frame.height)
        
        backgroundView.addSubview(postHeader)
        postHeader.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        postHeader.leftAnchor.constraint(equalTo: backgroundView.leftAnchor).isActive = true
        postHeader.rightAnchor.constraint(equalTo: backgroundView.rightAnchor).isActive = true
        postHeader.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        backgroundView.addSubview(backView)
        backView.topAnchor.constraint(equalTo: postHeader.bottomAnchor, constant: 1).isActive = true
        backView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1).isActive = true
        backView.heightAnchor.constraint(equalTo: backView.widthAnchor , multiplier: 1).isActive = true
        
        backView.addSubview(postImgView)
        postImgView.translatesAutoresizingMaskIntoConstraints = false
        postImgView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        postImgView.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        postImgView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        postImgView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        
        
        backView.addSubview(addImageBtn)
        addImageBtn.translatesAutoresizingMaskIntoConstraints = false
        addImageBtn.bottomAnchor.constraint(equalTo: postImgView.bottomAnchor).isActive = true
        addImageBtn.centerXAnchor.constraint(equalTo: postImgView.centerXAnchor).isActive = true
        addImageBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addImageBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addImageBtn.clipsToBounds = true
        addImageBtn.layer.cornerRadius = 20
        addImageBtn.setImage(#imageLiteral(resourceName: "technology"), for: .normal)
        addImageBtn.contentEdgeInsets.top = 4
        addImageBtn.contentEdgeInsets.bottom = 6
        addImageBtn.contentEdgeInsets.right = 5
        addImageBtn.contentEdgeInsets.left = 5
        addImageBtn.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.3)
        addImageBtn.layer.borderColor = UIColor.lightGray.cgColor
        addImageBtn.layer.borderWidth = 1
        
        backgroundView.addSubview(storeNameBackView)
        storeNameBackView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: -1)
        storeNameBackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1)
        storeNameBackView.heightAnchor.constraint(equalToConstant: 40)
        
        backgroundView.addSubview(placeBackView)
        placeBackView.topAnchor.constraint(equalTo: storeNameBackView.bottomAnchor, constant: -1)
        placeBackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1)
        placeBackView.heightAnchor.constraint(equalToConstant: 48)
        
        backgroundView.addSubview(contentBackView)
        contentBackView.topAnchor.constraint(equalTo: placeBackView.bottomAnchor, constant: -1)
        contentBackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1)
        contentBackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
       
        placeBackView.addSubview(googlePlaceBtn)
        googlePlaceBtn.translatesAutoresizingMaskIntoConstraints = false
        googlePlaceBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        googlePlaceBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        googlePlaceBtn.centerYAnchor.constraint(equalTo: placeBackView.centerYAnchor).isActive = true
        googlePlaceBtn.rightAnchor.constraint(equalTo: placeBackView.rightAnchor, constant: -4).isActive = true
        googlePlaceBtn.setImage(#imageLiteral(resourceName: "GMarker"), for: .normal)
        
        storeNameBackView.addSubview(storeNameTF)
        storeNameTF.translatesAutoresizingMaskIntoConstraints = false
        storeNameTF.leftAnchor.constraint(equalTo: storeNameBackView.leftAnchor, constant: 8).isActive = true
        storeNameTF.topAnchor.constraint(equalTo: storeNameBackView.topAnchor, constant: 8).isActive = true
        storeNameTF.heightAnchor.constraint(equalToConstant: 28).isActive = true
        storeNameTF.placeholder = "맛집이름 직접입력하기.."
        
        storeNameBackView.addSubview(toSearchBtn)
        toSearchBtn.translatesAutoresizingMaskIntoConstraints = false
        toSearchBtn.rightAnchor.constraint(equalTo: storeNameBackView.rightAnchor, constant: -8).isActive = true
        toSearchBtn.centerYAnchor.constraint(equalTo: storeNameBackView.centerYAnchor).isActive = true
        toSearchBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        toSearchBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        toSearchBtn.setImage(#imageLiteral(resourceName: "right-arrow-2"), for: .normal)
        toSearchBtn.setTitle("검색으로 찾기", for: .normal)
        toSearchBtn.setTitleColor(.black, for: .normal)
       
        placeBackView.addSubview(adressLb)
        adressLb.translatesAutoresizingMaskIntoConstraints = false
        adressLb.centerYAnchor.constraint(equalTo: placeBackView.centerYAnchor).isActive = true
        adressLb.leftAnchor.constraint(equalTo: placeBackView.leftAnchor, constant: 8).isActive = true
        adressLb.heightAnchor.constraint(equalToConstant: 28).isActive = true
        adressLb.text = "위치추가"
        
        contentBackView.addSubview(contentIntroLb)
        contentIntroLb.translatesAutoresizingMaskIntoConstraints = false
        contentIntroLb.leftAnchor.constraint(equalTo: contentBackView.leftAnchor, constant: 8).isActive = true
        contentIntroLb.topAnchor.constraint(equalTo: contentBackView.topAnchor, constant: 2).isActive = true
        contentIntroLb.heightAnchor.constraint(equalToConstant: 16).isActive = true
        contentIntroLb.text = "글내용 입력하기"
        contentIntroLb.font = UIFont(name: "system", size: 8)
        
        contentBackView.addSubview(contentTextview)
        contentTextview.translatesAutoresizingMaskIntoConstraints = false
        contentTextview.topAnchor.constraint(equalTo: contentIntroLb.bottomAnchor).isActive = true
        contentTextview.bottomAnchor.constraint(equalTo: contentBackView.bottomAnchor).isActive = true
        contentTextview.leftAnchor.constraint(equalTo: contentBackView.leftAnchor).isActive = true
        contentTextview.rightAnchor.constraint(equalTo: contentBackView.rightAnchor).isActive = true
        
        postHeader.addSubview(postDoneBtn)
        postDoneBtn.translatesAutoresizingMaskIntoConstraints = false
        postDoneBtn.centerYAnchor.constraint(equalTo: postHeader.centerYAnchor).isActive = true
        postDoneBtn.rightAnchor.constraint(equalTo: postHeader.rightAnchor, constant: -8).isActive = true
        postDoneBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        postDoneBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        postDoneBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        
        postHeader.addSubview(backToMainBtn)
        backToMainBtn.translatesAutoresizingMaskIntoConstraints = false
        backToMainBtn.centerYAnchor.constraint(equalTo: postHeader.centerYAnchor).isActive = true
        backToMainBtn.leftAnchor.constraint(equalTo: postHeader.leftAnchor, constant: 8).isActive = true
        backToMainBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backToMainBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backToMainBtn.setImage(#imageLiteral(resourceName: "back_black"), for: .normal)
    }

}
