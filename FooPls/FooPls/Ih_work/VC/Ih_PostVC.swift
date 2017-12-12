
import UIKit
import Photos
import FirebaseAuth

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: - Property
    var dataCenter : DataCenter!
    var userInfo = Auth.auth().currentUser
    
    @IBOutlet var postImgView: UIImageView!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var adressTextF: UITextField!
    @IBOutlet var nameTextF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - show Photolivrary
    @IBAction func selectImg(sender: AnyObject) {
        //imgpicker
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .photoLibrary
        present(photo, animated: true, completion: nil)
    }
    
    // MARK: image pick
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image =  info[UIImagePickerControllerOriginalImage]
            as? UIImage
        {
             self.postImgView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Post upload
    @IBAction func postSaveAndUpload(sender: AnyObject) {
    
        guard let uid = userInfo?.uid else {return}
        print(uid)
        guard let image = postImgView.image, let name = nameTextF.text,
            let adress = adressTextF.text, let contents = postTextView.text else {return}
        DispatchQueue.main.async {
            self.dataCenter?.postUpload(uid: uid, storeimg: image, storeName: name, storeAdress: adress, contents: contents)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
