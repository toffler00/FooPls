
import UIKit

class MainCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Variable
    @IBOutlet weak var introImgView: UIImageView!

    var cell : CustomCell!
    var postData = [PostModel]()
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - CollectionView Delegate & Datasource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
      let count = postData.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: (view.frame.width - 30) / 2, height: 205)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        // setUPCell
        setUpCell()
        
        cell.cellTitleLb.text = postData[indexPath.row].storeName
        cell.cellAdressLb.text = postData[indexPath.row].storeAdress
        cell.cellImageView.image = postData[indexPath.row].storeImg
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    // CollectionView Delegate & Datasource_End
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    }

extension MainCollectionView {
    func setUpCell() {
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true

        cell.cellImageView.backgroundColor = UIColor.cyan
        cell.cellImageView.layer.cornerRadius = 5
        cell.cellImageView.layer.masksToBounds = true
    }
}

