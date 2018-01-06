
import UIKit
import PagingKit
import Firebase
import SnapKit

class FollowProfileViewController: UIViewController {
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var reference = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    var userNickname: String?
    
    var followerBtn: UIButton = {
        let followerBtn = UIButton()
        followerBtn.addTarget(self, action: #selector(followerBtnAction), for: .touchUpInside)
        return followerBtn
    }()
    
    var followingBtn: UIButton = {
        let followingBtn = UIButton()
        followingBtn.addTarget(self, action: #selector(followingBtnAction), for: .touchUpInside)
        return followingBtn
    }()
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileBGImgView: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    @IBOutlet weak var followerStackView: UIStackView!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingStackView: UIStackView!
    @IBOutlet weak var followingLabel: UILabel!
    
    var dataSource: [(titleImg: String, title: String, vc: UIViewController)]?
    
    let mainColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    let normalColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaging()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //MARK: - Method
    //기본 UI인 요소를 초기화 시킴
    private func setupUI() {
        profileView.layer.borderColor = mainColor.cgColor
        profileView.layer.borderWidth = 3
        profileView.layer.cornerRadius = (profileView.frame.width / 2) - 3
        followerStackView.addSubview(followerBtn)
        followerBtn.snp.makeConstraints {
            $0.top.equalTo(followerStackView)
            $0.bottom.equalTo(followerStackView)
            $0.right.equalTo(followerStackView)
            $0.left.equalTo(followerStackView)
        }
        followingStackView.addSubview(followingBtn)
        followingBtn.snp.makeConstraints {
            $0.top.equalTo(followingStackView)
            $0.bottom.equalTo(followingStackView)
            $0.right.equalTo(followingStackView)
            $0.left.equalTo(followingStackView)
        }
    }
    
    @objc func followerBtnAction() {
        performSegue(withIdentifier: "Follower", sender: nil)
    }
    
    @objc func followingBtnAction() {
        performSegue(withIdentifier: "Following", sender: nil)
    }
    
    //파이어베이스 데이터 베이스 저장된 프로파일 값을 불러옴
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
    
    //페이징킷 초기 셋업
    private func setupPaging() {
        //페이징에 들어갈 뷰 컨트롤러 설정
        let timelineSB = UIStoryboard(name: "TJTimeline", bundle: nil)
        let timelineVC = timelineSB.instantiateViewController(withIdentifier: "TJTimelineViewController")
        let likeSB = UIStoryboard(name: "TJLike", bundle: nil)
        let likeVC = likeSB.instantiateViewController(withIdentifier: "TJLikeViewController")
        //        let listSB = UIStoryboard(name: "TJList", bundle: nil)
        //        let listVC = listSB.instantiateViewController(withIdentifier: "TJListViewController")
        //        let bookmarkSB = UIStoryboard(name: "TJBookmark", bundle: nil)
        //        let bookmarkVC = bookmarkSB.instantiateViewController(withIdentifier: "TJBookmarkViewController")
        
        //페이징에 해당하는 뷰컨트롤러와 이미지 타이틀을 저장
        dataSource = [(titleImg: "timeline",title: "타임라인", vc: timelineVC),
                      (titleImg: "like",title: "가고싶다", vc: likeVC)]
        
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
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - extension
//MARK: - PagingMenuViewControllerDataSource
extension FollowProfileViewController: PagingMenuViewControllerDataSource {
    //PagingKit의 메뉴 갯수 - 초기에 4개로 지정.
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource?.count ?? 0
    }
    
    //PagingKit 하나의 셀의 너비 - 셀의 너비는 전체 뷰의 넓이에서 페이지의 갯수로 나눠준 값을 넣어주었다. 정확한게 등분이 되게 하기 위해
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return self.view.frame.width / CGFloat(dataSource!.count)
    }
    
    //셀의 정보 - 각 셀마다의 이미지와 레이블에 기존에 데이터를 읽은 배열의 값을 넣어준다.
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        cell.titleImgView.image = UIImage(named: dataSource![index].titleImg)
        cell.titleLabel.text = dataSource![index].title
        return cell
    }
}

//MARK: - PagingContentViewControllerDataSource
extension FollowProfileViewController: PagingContentViewControllerDataSource {
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
extension FollowProfileViewController: PagingMenuViewControllerDelegate {
    //페이지가 이동할 때마다 불림, 메뉴뷰에 해당
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        pagingColorHandler(viewController: viewController, page: page)
    }
}

//MARK: - PagingContentViewControllerDelegate
extension FollowProfileViewController: PagingContentViewControllerDelegate {
    //페이지가 이동할 때마다 불림, 컨텐츠 뷰에 해당
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
