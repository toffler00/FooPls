
import UIKit
import Photos

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    
    @IBAction func postSaveAndUpload(sender: AnyObject) {
        guard postTextView.text != nil,
              adressTextF.text != nil,
              nameTextF.text != nil,
              postImgView.image != nil
            else {return}
        
        let name = nameTextF.text
        let adress = adressTextF.text
        let content = postTextView.text
        let image = postImgView.image
      
        let datacenter : DataCenter?
       
        print("포스트업로드성공")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
