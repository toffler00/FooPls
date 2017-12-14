
import UIKit
import Firebase
import GooglePlacePicker

class TJDetailTimelineViewController: UIViewController {

    //MARK: - Firebase
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    
    //MARK: - Property
    var postingIndex: String = ""
    var selectedDate: String = ""
    var longitude: Double?
    var latitude: Double?
    var adress: String?
    var selectedKey: String?
    
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailTitleTextField: UITextField!
    @IBOutlet weak var detailImgView: UIImageView!
    @IBOutlet weak var detailLocationTitleLabel: UILabel!
    @IBOutlet weak var detailLocationAdressLabel: UILabel!
    @IBOutlet weak var detailContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedKey!)
        loadData()
    }
    
    private func loadData() {
        reference.child("users").child(userID!).child("calendar").child(selectedKey!).observe(.value) { [unowned self] (snapshot) in
            print(self.selectedKey!)
            if let value = snapshot.value as? [String: Any] {
                self.detailDateLabel.text = value["date"] as? String
                self.detailTitleTextField.text = value["title"] as? String
                let imgURL = value["photoID"] as? String
                self.detailImgView.kf.setImage(with: URL(string: imgURL!))
                self.detailLocationTitleLabel.text = value["locationTitle"] as? String
                self.detailLocationAdressLabel.text = value["adress"] as? String
                self.detailContentTextView.text = value["content"] as? String
            }
        }
            
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 글쓰기 버튼
    @IBAction func writeBtnAction(_ sender: UIButton) {
        guard let contentTitle = detailTitleTextField.text else { return }
        guard let _ = detailImgView.image else { return }
        guard let locationTitle = detailLocationTitleLabel.text else { return }
        guard let contentTxtView = detailContentTextView.text else { return }
        
        let alertSheet = UIAlertController(title: "등록", message: "이 글을 등록하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) { [unowned self] (action) in
            guard let uploadImg = UIImageJPEGRepresentation(self.detailImgView.image!, 0.3) else { return }
            
            
            //uuid 값 파이어베이스에서 키 값으로 받아와서 저장
            
            
            let uuid = UUID().uuidString
            Storage.storage().reference().child("calendar_images").child(uuid).putData(uploadImg, metadata: nil, completion: { [unowned self] (metaData, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }else {
                    guard let photoID = metaData?.downloadURL()?.absoluteString else { return }
                    
                    let calendarDic = ["title": contentTitle,
                                       "author": self.userID!,
                                       "content": contentTxtView,
                                       "photoID": photoID,
                                       "locationTitle": locationTitle,
                                       "longitude": self.longitude!,
                                       "latitude": self.latitude!,
                                       "adress": self.adress!,
                                       "date": self.selectedDate,
                                       "postTime": ServerValue.timestamp()] as [String: Any]
                    // MARK: Noti
                    NotificationCenter.default.post(name: .reload, object: contentTitle)
                    self.reference.child("users").child(self.userID!).child("calendar").childByAutoId().setValue(calendarDic)
                    let key = self.reference.child("users").childByAutoId().key
                    let postKey = NSArray(array: [key])
                    self.reference.child("posts").setValue(postKey)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alertSheet.addAction(okAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
    
    @IBAction func detailImgBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func detailLocationBtnAction(_ sender: UIButton) {
    }
}
