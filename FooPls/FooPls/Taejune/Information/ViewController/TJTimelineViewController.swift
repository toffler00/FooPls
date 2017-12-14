
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
        myPostingTitles.removeAll()
        myPostingAdress.removeAll()
        myPostingImgs.removeAll()
        myPostingIndex.removeAll()
        reference.child("users").child(userID!).child("calendar").observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String : [String: Any]] {
                for (key, postingDic) in value {
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

extension TJTimelineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        selectedKey = myPostingIndex[indexPath.item]
        print(selectedKey)
        performSegue(withIdentifier: "TJDetailTimeline", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TJDetailTimeline" {
            let destinationVC = segue.destination as! TJDetailTimelineViewController
            
            destinationVC.selectedKey = self.selectedKey
            print(destinationVC.selectedKey)
        }
    }
}

extension TJTimelineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: (self.view.frame.width - 60) / 2, height: (2 * self.view.frame.height) / 3)
        return cellSize
    }
}

