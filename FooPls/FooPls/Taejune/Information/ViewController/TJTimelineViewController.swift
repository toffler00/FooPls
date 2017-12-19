
import UIKit
import PagingKit
import Firebase
import Kingfisher

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
        reference.child("users").child(userID!).child("calendar").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String : [String: Any]] {
                self.myPostingTitles.removeAll()
                self.myPostingAddress.removeAll()
                self.myPostingImgs.removeAll()
                self.myPostingIndex.removeAll()
                self.myPostingDate.removeAll()
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
    
    //MARK: - 자기가 쓴 글을 지우는데 지운 후에 다시 데이터를 로드할 때 순서가 가끔씩 뒤바뀜, 지울 때 Storage에 있는 사진 파일도 삭제 해야 함
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let alertSheet = UIAlertController(title: "삭제", message: "정말로 삭제하시겠습니끼?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let okAction = UIAlertAction(title: "예", style: .default) { [weak self]  (action) in
            guard let `self` = self else { return }
            let removeKey = self.myPostingIndex[sender.tag]
            self.reference.child("users").child(self.userID!).child("calendar").child(removeKey).removeValue()
            self.myPostingCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alertSheet.addAction(okAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
}

extension TJTimelineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPostingIndex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostingCell", for: indexPath) as! MyPostingCell
        
        cell.deleteBtn.tag = indexPath.item
        
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

