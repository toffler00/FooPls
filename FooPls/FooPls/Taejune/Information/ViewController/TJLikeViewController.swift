
import UIKit

class TJLikeViewController: UIViewController {

    var dummyData: [PostModel] = DataCenter.main.dummyData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dummyData", self.dummyData)
    }
    
    @IBAction func likedBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "noLike"), for: .normal)
        }else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "like"), for: .normal)
        }
    }
    
}

extension TJLikeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikedCell", for: indexPath) as! LikedCell
        cell.likedImageView.kf.setImage(with: URL(string: dummyData[indexPath.item].imageurl!))
        cell.likedDate.text = dummyData[indexPath.item].date
        cell.likedTitle.text = dummyData[indexPath.item].nickName
        cell.likedAddress.text = dummyData[indexPath.item].storeAddress
        return cell
    }
    
    
}

extension TJLikeViewController: UICollectionViewDelegate {
    
}

extension TJLikeViewController: UICollectionViewDelegateFlowLayout {
    //셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: (self.view.frame.width - 60) / 2, height: (2 * self.view.frame.height) / 3)
        return cellSize
    }
}
