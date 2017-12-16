
import UIKit



class DetailPageView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,     UICollectionViewDelegate, SendSelectedCellIntfo {


    @IBOutlet weak var pageTitleLb: UILabel!
    @IBOutlet weak var detailPageCollectionView: UICollectionView!
    
    
    var postData : [PostModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainVCdelegate = MainCollectionView()
        mainVCdelegate.delegate = self
        mainVCdelegate.sendToDetailPageView()
        print("DetailViewPage \(postData.count)")
    }

    
    
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
        return cell
    }
    
    @IBAction func returnMainView(_ sender: Any) {
        
        performSegue(withIdentifier: "returnMainView", sender: self)
    }
   
    func selectedCellInfo(nickName: String, uid: String) {
        print(nickName)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
}
