
import UIKit

class DetailPageView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    @IBOutlet weak var pageTitleLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPageCell", for: indexPath) as! DetailPageCell
        return cell
    }
    
    @IBAction func returnMainView(_ sender: Any) {
        
        performSegue(withIdentifier: "returnMainView", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
}
