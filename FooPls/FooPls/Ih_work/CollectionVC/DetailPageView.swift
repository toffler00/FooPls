
import UIKit

class DetailPageView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    @IBOutlet weak var pageTitleLb: UILabel!
    
    
    var postData : [PostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewPage \(postData.count)")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPageCell", for: indexPath) as! DetailPageCell
        cell.storeNameLb.text = postData[indexPath.row].storeName
        cell.adressLb.text = postData[indexPath.row].storeAdress
        return cell
    }
    
    @IBAction func returnMainView(_ sender: Any) {
        
        performSegue(withIdentifier: "returnMainView", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
}
