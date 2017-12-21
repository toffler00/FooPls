
import UIKit
import SDWebImage
import Firebase
import FirebaseStorage


class DetailPageView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,     UICollectionViewDelegate, SendSelectedCellIntfo {


    //MARK : - variable
    @IBOutlet weak var pageTitleLb: UILabel!
    @IBOutlet weak var detailPageCollectionView: UICollectionView!
    
    
    var postData : [PostModel] = DataCenter.main.mainVCpostsData
    var cell : CustomCell!
    
    
    //MARK : - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainVCdelegate = MainCollectionView()
        mainVCdelegate.delegate = self
        mainVCdelegate.sendToDetailPageView()
        print("DetailViewPage \(postData.count)")
    }

    //MARK : - collectionview layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //MARK : - collectionview datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("타이밍이언제냐")
        return postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPageCell", for: indexPath) as! DetailPageCell
        cell.storeNameLb.text = postData[indexPath.item].storeName
        cell.adressLb.text = postData[indexPath.item].storeAddress
        cell.showStoryLb.text = postData[indexPath.item].contentsText
        cell.nickNameLb.text = postData[indexPath.item].nickName
        cell.thoughtsLb.text = postData[indexPath.item].thoughts

        
        if let storeImgUrl = self.postData[indexPath.row].imageurl {
            let url = URL(string: storeImgUrl)
            cell.postImgView.sd_setImage(with: url!, completed: { (image, error, cacheType, url) in
                if error != nil {
                    print(error.debugDescription)
                    cell.postImgView.image = #imageLiteral(resourceName: "noimage")
                }
                cell.postImgView.contentMode = .scaleAspectFill
                cell.postImgView.clipsToBounds = true
            })
        }else {
            cell.postImgView.image = #imageLiteral(resourceName: "noimage")
        }
        cell.thoughtsBackView.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        cell.thoughtsBackView.layer.borderWidth = 1
        return cell
    }
    
    @IBAction func returnMainView(_ sender: Any) {
        print("눌리긴하는거야?")
        
        
    }
   
    func selectedCellInfo(nickName: String, uid: String) {
        print(nickName)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
}
