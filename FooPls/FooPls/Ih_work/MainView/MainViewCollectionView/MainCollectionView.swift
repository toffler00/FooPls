
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

protocol  SendSelectedCellIntfo {
    func selectedCellInfo(nickName : String, uid : String)
}

class MainCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var delegate : SendSelectedCellIntfo?
    // MARK: - Variable
    
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var cell : CustomCell!
    var dataCenter = DataCenter()
    var postData = [PostModel]()
    var currentUser = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.mainVCData,
                                               object: nil, queue: nil) { (mainVCData) in
            let mainVCPostData = mainVCData.object as! [PostModel]
            for temp in mainVCPostData {
                self.postData.append(temp)
            }
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
        
//        DispatchQueue.main.async {
//            self.loadDataToMainCollectionView()
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainCollectionView.reloadData()
    }
    func sendToDetailPageView() {
        delegate?.selectedCellInfo(nickName: "toffler", uid: "uid")
    }
    
    //MARK: - loadData To Main CollectionView
//    func loadDataToMainCollectionView() {
//        print("self.postData.count")
//        guard let uid = self.currentUser?.uid else {return}
//        print(uid)
//        ref = Database.database().reference()
//        ref.child("users").child(uid).child("posts").observeSingleEvent(of: .value) { (snapshot) in
//            guard let data = snapshot.value as? [ String: [String : String]] else {return}
//            for (_, dic) in data {
//                guard let name = dic["storename"], let address = dic["storeaddress"],
//                    let url = dic["imageurl"], let content = dic["content"] else {return}
//                let posts = PostModel(storeName: name, storeAddress: address, contentText: content, storeImgUrl: url)
//                self.postData.append(posts)
//                self.mainCollectionView.reloadData()
//            }
//            
//        }
//
//    }
    
    
    // MARK: - CollectionView Delegate & Datasource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        print(self.postData.count)
        return self.postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: (view.frame.width - 24) / 2, height: 300)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        // setUPCell
        setUpCell()
        
        cell.cellTitleLb.text = self.postData[indexPath.row].storeName
        cell.cellAdressLb.text = self.postData[indexPath.row].storeAddress
        cell.nickNameLb.text = self.postData[indexPath.row].nickName
        cell.thoughtsLb.text = self.postData[indexPath.row].thoughts
        
        // url to image - FirebaseUI
        let storeImgUrl = self.postData[indexPath.row].storeImgUrl
        let url = URL(string: storeImgUrl!)
        cell.cellImageView.sd_setImage(with: url!)
        

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        
        
        
        print("이건불림?")
//        if let nextVC = segue.destination as? DetailPageView {
//            for temp in self.postData {
//                nextVC.postData.append(temp)
//            }
//        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("불림?")
       
    }
  
    // CollectionView Delegate & Datasource_End
    
    func toDetailPage() {
        //need data list : nickname , adress, date, content, image
        
        performSegue(withIdentifier: "ToDetailContent", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainCollectionView {
    func setUpCell() {
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cell.layer.borderWidth = 1

        cell.cellImageView.layer.cornerRadius = 5
        cell.cellImageView.layer.masksToBounds = true
    }
}

