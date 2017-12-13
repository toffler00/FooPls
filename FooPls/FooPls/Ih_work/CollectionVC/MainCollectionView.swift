
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class MainCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Variable

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var cell : CustomCell!
    var dataCenter = DataCenter()
    var postData = [PostModel]()
    var currentUser = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.loadDataToMainCollectionView()
        }
        
    }
    
    //MARK: - loadData To Main CollectionView
    func loadDataToMainCollectionView() {
        print("self.postData.count")
        guard let uid = self.currentUser?.uid else {return}
        ref = Database.database().reference()
        ref.child("users").child(uid).child("posts").observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [ String: [String : String]] else {return}
            for (_, dic) in data {
                guard let name = dic["sotrename"], let adress = dic["adress"],
                    let url = dic["imageurl"], let content = dic["content"] else {return}
                let posts = PostModel(storeName: name, storeAdress: adress, contentText: content, storeImgUrl: url)
                self.postData.append(posts)
                self.mainCollectionView.reloadData()
            }
            print(self.postData.count)
        }
    }
    
    // MARK: - CollectionView Delegate & Datasource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: (view.frame.width - 24) / 2, height: 216)
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
        cell.cellAdressLb.text = self.postData[indexPath.row].storeAdress
        
        // url to image - FirebaseUI
        let storeImgUrl = self.postData[indexPath.row].storeImgUrl
        let url = URL(string: storeImgUrl!)
        cell.cellImageView.sd_setImage(with: url!)
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      
        
        toDetailPage()
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

