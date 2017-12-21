
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
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupUI() {
        profileView.layer.borderColor = mainColor.cgColor
        profileView.layer.borderWidth = 3
        profileView.layer.cornerRadius = (profileView.frame.width / 2) - 3
        
    }
    
    private func loadData(){
        reference.child("users").child(userID!).child("profile").observe(.value) { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String : Any] {
                self.userNickname = value["nickname"] as? String
                self.profileNickname.text = self.userNickname
                let profileImg = value["photoID"] as? String
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
        
        //처음 페이징 0번에해당하는 레이블과 이미지의 tint를 설정하기 위함
        let initialCell = menuViewController.cellForItem(at: 0) as! MenuCell
        initialCell.titleImgView.tintImageColor(color: mainColor)
        initialCell.titleLabel.textColor = mainColor
    }
    //메뉴나 컨텐츠는 segue로 되어 있고 각각 프로토콜을 지정해줘야 한다.
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
    //MARK: - 페이지가 바뀔때마다 메뉴에 해당하는 색을 결정하는 메소드
    private func pagingColorHandler (viewController: PagingMenuViewController, page: Int) {
        for index in 0...(dataSource!.count - 1) {
            let cell = viewController.cellForItem(at: index) as! MenuCell
            if cell.index == page {
                cell.titleLabel.textColor = mainColor
                cell.titleImgView.tintImageColor(color: mainColor)
            }else {
                cell.titleLabel.textColor = normalColor
                cell.titleImgView.tintImageColor(color: normalColor)
            }
        }
        contentViewController.scroll(to: page, animated: true)
    }
}
//MARK: - extension
//MARK: - PagingMenuViewControllerDataSource
extension TJProfileViewController: PagingMenuViewControllerDataSource {
    //PagingKit의 메뉴 갯수
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource?.count ?? 0
    }
    //PagingKit 하나의 셀의 너비
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return self.view.frame.width / CGFloat(dataSource!.count)
    }
    //셀의 정보
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        cell.titleImgView.image = UIImage(named: dataSource![index].titleImg)
        cell.titleLabel.text = dataSource![index].title
        return cell
    }
}
//MARK: - PagingContentViewControllerDataSource
extension TJProfileViewController: PagingContentViewControllerDataSource {
    //PagingKit의 컨텐츠 갯수
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource?.count ?? 0
    }
    //각각 인덱스에 해당하는 컨텐츠가 무엇인지 결정
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource![index].vc
    }
}
//MARK: - PagingMenuViewControllerDelegate
extension TJProfileViewController: PagingMenuViewControllerDelegate {
    //페이지가 이동할 때마다 불림, 메뉴뷰에 해당
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        pagingColorHandler(viewController: viewController, page: page)
    }
}
//MARK: - PagingContentViewControllerDelegate
extension TJProfileViewController: PagingContentViewControllerDelegate {
    //페이지가 이동할 때마다 불림, 컨텐츠 뷰에 해당
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}


