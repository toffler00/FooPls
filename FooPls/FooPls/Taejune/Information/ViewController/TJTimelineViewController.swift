
import UIKit
import PagingKit
import Firebase
import Kingfisher
import SDWebImage

class TJTimelineViewController: UIViewController {
    
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    var myPostingIndex: [String] = []
    var myPostingImgs: [URL] = []
    var myPostingTitles: [String] = []
    var myPostingAddress: [String] = []
    var myPostingDate: [String] = []
    var selectedKey: String?
    
    @IBOutlet weak var myPostingCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDate()
    }
    
    private func loadDate() {
        reference.child("users").child(userID!).child("calendar").observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String : [String: Any]] {
                self.myPostingTitles.removeAll()
                self.myPostingAddress.removeAll()
                self.myPostingImgs.removeAll()
                self.myPostingIndex.removeAll()
                for (key, postingDic) in value {
                    let postingTitle = postingDic["title"] as! String
                    let postingAddress = postingDic["address"] as! String
                    let postingDate = postingDic["date"] as! String
                    let postingImgURL = URL(string: postingDic["photoID"] as! String)
                    self.myPostingTitles.append(postingTitle)
                    print("title: ", self.myPostingTitles)
                    self.myPostingAddress.append(postingAddress)
                    self.myPostingImgs.append(postingImgURL!)
                    self.myPostingDate.append(postingDate)
                    self.myPostingIndex.append(key)
                    self.myPostingCollectionView.reloadData()
                }
            }
        }
    }
}

extension TJTimelineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPostingIndex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostingCell", for: indexPath) as! MyPostingCell
        cell.postingTitle.text = myPostingTitles[indexPath.item]
        cell.postingAddress.text = myPostingAddress[indexPath.item]
        cell.myPostingImgVIew.kf.setImage(with: myPostingImgs[indexPath.item])
        cell.postingDate.text = myPostingDate[indexPath.item]
        return cell
    }
}

extension TJTimelineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedKey = myPostingIndex[indexPath.item]
        performSegue(withIdentifier: "TJDetailTimeline", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TJDetailTimeline" {
            let destinationVC = segue.destination as! TJDetailTimelineViewController
            
            destinationVC.selectedKey = self.selectedKey
        }
    }
}

extension TJTimelineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: (self.view.frame.width - 60) / 2, height: (2 * self.view.frame.height) / 3)
        return cellSize
    }
}

