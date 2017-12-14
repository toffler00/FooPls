
import UIKit
import Firebase

class TJModifyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    
    let mainColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var profileBGImgView: UIImageView!
    @IBOutlet weak var profilePhotoView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhotoView.layer.borderColor = mainColor.cgColor
        profilePhotoView.layer.borderWidth = 3
    }

    @IBAction func profilePhotoBtnAction(_ sender: UIButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    // MARK : - ImgPickerView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {

            profileImgView.image = img
            profileBGImgView.image = img
            guard let uploadData = UIImageJPEGRepresentation(img, 0.3) else { return }
            // Save imageData
            Storage.storage().reference().child("profile_images").child(userID!).putData(uploadData, metadata: nil, completion: { [weak self](metadata, error) in
                guard let `self` = self else { return }
                guard let profilePhotoID = metadata?.downloadURL()?.absoluteString else { return }

                print(profilePhotoID)
                self.reference.child("users").child(self.userID!).updateChildValues(["profilePhotoID": profilePhotoID], withCompletionBlock: { (error, databaseRef) in
                })
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
