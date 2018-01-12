
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
    var postData : [PostModel] = DataCenter.main.mainVCpostsData
    var currentUser = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataCenter.main.getUserUidAndNickName()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("뷰윌어피어 불려지는가?")
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
        
    }
    func sendToDetailPageView() {
        delegate?.selectedCellInfo(nickName: "toffler", uid: "uid")
    }
    
    @IBAction func isLikeBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "noLike"), for: .normal)
        }else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "like"), for: .normal)
        }
    }
    
    //MARK: - loadData To Main CollectionView
    
    
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
       
        cell.cellTitleLb.text = "\(indexPath.item + 1).\(self.postData[indexPath.item].storeName)"
        cell.cellAdressLb.text = self.postData[indexPath.item].storeAddress
        
        if self.postData[indexPath.row].nickName == "" {
            cell.nickNameLb.text = "FooPls"
        }else {
            cell.nickNameLb.text = self.postData[indexPath.item].nickName
        }
        
        cell.thoughtsLb.text = self.postData[indexPath.item].thoughts
        
        // url to image - FirebaseUI
        
        if let storeImgUrl = self.postData[indexPath.item].imageurl {
            let url = URL(string: storeImgUrl)
            cell.cellImageView.sd_setImage(with: url!)
        }else {
            cell.cellImageView.image = #imageLiteral(resourceName: "noimage")
        }
        
        

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
        cell.layer.masksToBounds = true
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds , cornerRadius: 1).cgPath

        cell.cellImageView.layer.cornerRadius = 2
        cell.cellImageView.contentMode = .scaleAspectFill
        cell.cellImageView.layer.masksToBounds = true
        
        cell.nickNameLb.lineBreakMode = .byWordWrapping
        cell.nickNameLb.font = UIFont.systemFont(ofSize: 12)
        
        cell.cellTitleLb.font = UIFont.systemFont(ofSize: 14)
        cell.cellTitleLb.lineBreakMode = .byClipping
        
        cell.cellAdressLb.lineBreakMode = .byWordWrapping
        cell.cellAdressLb.font = UIFont.systemFont(ofSize: 12)
        
        cell.thoughtsLb.font = UIFont.boldSystemFont(ofSize: 12)
        cell.thoughtsLb.numberOfLines = 0
    }
}

