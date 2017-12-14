
import UIKit
import PagingKit
import Firebase

class TJProfileViewController: UIViewController {

    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    var userNickname: String?
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileBGImgView: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    
    var dataSource: [(titleImg: String, title: String, vc: UIViewController)]?
    
    let mainColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    let normalColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaging()
        profileView.layer.borderColor = mainColor.cgColor
        profileView.layer.borderWidth = 3
        //loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        reference.child("users").child(userID!).observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String : Any] {
                self.userNickname = value["nickname"] as? String
                self.profileNickname.text = self.userNickname
                let profileImg = value["profilePhotoID"] as? String
                self.profileImgView.kf.setImage(with: URL(string: profileImg!))
                self.profileBGImgView.kf.setImage(with: URL(string: profileImg!))
            }
        }
    }
    
    //MARK: - 페이징킷 초기 셋업
    private func setupPaging() {
        let timelineSB = UIStoryboard(name: "TJTimeline", bundle: nil)
        let timelineVC = timelineSB.instantiateViewController(withIdentifier: "TJTimelineViewController")
        let likeSB = UIStoryboard(name: "TJLike", bundle: nil)
        let likeVC = likeSB.instantiateViewController(withIdentifier: "TJLikeViewController")
        let listSB = UIStoryboard(name: "TJList", bundle: nil)
        let listVC = listSB.instantiateViewController(withIdentifier: "TJListViewController")
        let bookmarkSB = UIStoryboard(name: "TJBookmark", bundle: nil)
        let bookmarkVC = bookmarkSB.instantiateViewController(withIdentifier: "TJBookmarkViewController")
        
        dataSource = [(titleImg: "timeline",title: "타임라인", vc: timelineVC),
                      (titleImg: "like",title: "좋아요", vc: likeVC),
                      (titleImg: "list",title: "리스트", vc: listVC),
                      (titleImg: "bookmark",title: "북마크", vc: bookmarkVC)]
        
        //페이징 메뉴셀과 메뉴 포커싱 뷰를 등록
        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        
        //페이징컨트롤러는 두가지의 뷰컨트롤러로 나뉜다. 메뉴뷰컨트롤러와 컨텐츠뷰컨트롤러로 나뉘는데 처음에 초기화할때 로드한다.
        menuViewController.reloadData(with: 0)
        contentViewController.reloadData(with: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
        }
    }
}

extension TJProfileViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource?.count ?? 0
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return self.view.frame.width / CGFloat(dataSource!.count)
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        cell.titleImgView.image = UIImage(named: dataSource![index].titleImg)
        cell.titleLabel.text = dataSource![index].title
        return cell
    }
}

extension TJProfileViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource?.count ?? 0
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource![index].vc
    }
}

extension TJProfileViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
//          페이지 이동시에 Menucell에 컬러를 바꿔주려고 했지만 이미지 때문에 보류
//        for index in 0...(dataSource!.count - 1) {
//            let cell = viewController.cellForItem(at: index) as! MenuCell
//            if cell.index == page {
//                //cell.titleLabel.textColor = mainColor
//                //cell.titleImgView. = mainColor
//                cell.backgroundColor = mainColor
//            }else {
//                //cell.titleLabel.textColor = normalColor
//                cell.backgroundColor = .white
//            }
//        }
        contentViewController.scroll(to: page, animated: true)
    }
}

extension TJProfileViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}

