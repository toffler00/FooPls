
import UIKit
import Photos
import FirebaseAuth

class PostVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, ImagePickerDelegate {
    
    

    
    //MARK: - Property
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
    
    var dataCenter : DataCenter!
    var userInfo = Auth.auth().currentUser
    
    @IBOutlet weak var postHeader: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet var postImgView: UIImageView!
    @IBOutlet weak var placeBackView: UIView!
    @IBOutlet weak var storeNameBackView: UIView!
    @IBOutlet weak var contentBackView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - show Photolibrary
    @objc func selectImg(sender: UIButton) {
        //imgpicker
        let imagePicker = ImagePickerVC(collectionViewLayout: UICollectionViewFlowLayout())
        let navi = UINavigationController(rootViewController: imagePicker)
        imagePicker.delegate = self
        present(navi, animated: true, completion: nil)
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
        guard let image = postImgView.image, let name = storeNameTF.text,
            let adress = storeAdressLb.text, let contents = contentTextview.text else {return}
        DispatchQueue.main.async {
            self.dataCenter?.postUpload(uid: uid, storeimg: image, storeName: name, storeAdress: adress, contents: contents)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlerBack() {
        dismiss(animated: true, completion: nil)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension PostVC {
    
    func setUI() {
        
        view.addSubview(addImageBtn)
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
