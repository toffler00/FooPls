
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
    var myPostingAdress: [String] = []
    
    @IBOutlet weak var myPostingCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = Database.database().reference()
        loadDate()
        
    }
    
    private func loadDate() {
        reference.child("users").child(userID!).child("calendar").observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String : [String: Any]] {
                for (key, postingDic) in value {
                    print(key)
                    print(postingDic)
                    let postingTitle = postingDic["title"] as! String
                    let postingAdress = postingDic["adress"] as! String
                    let postingImgURL = URL(string: postingDic["photoID"] as! String)
                    self.myPostingTitles.append(postingTitle)
                    self.myPostingAdress.append(postingAdress)
                    self.myPostingImgs.append(postingImgURL!)
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
        cell.postingAdress.text = myPostingAdress[indexPath.item]
        cell.myPostingImgVIew.kf.setImage(with: myPostingImgs[indexPath.item])
        return cell
    }
    
    
}

