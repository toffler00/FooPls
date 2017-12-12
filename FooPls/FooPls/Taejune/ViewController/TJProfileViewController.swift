
import UIKit
import PagingKit
import Firebase

class TJProfileViewController: UIViewController {

    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileBGImgView: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    static var viewController: (UIColor) -> UIViewController = { (color) in
        let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }
    
    //var dataSource = [(menuTitle: "test1", vc: viewController(.yellow)), (menuTitle: "test2", vc: viewController(.blue)), (menuTitle: "test3", vc: viewController(.yellow))]
    
//    let dataSource: [(menu: String, content: UIViewController)] = ["내 정보", "좋아요", "미정", "미정"].map {
//        let title = $0
//        let vc = UIStoryboard(name: "TJTemp", bundle: nil).instantiateInitialViewController() as! TJTempViewController
//        return (menu: title, content: vc)
//    }
    
    var dataSource: [(title: String, vc: UIViewController)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaging()
        profileView.layer.borderColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 75.0/255.0, alpha: 1.0).cgColor
        profileView.layer.borderWidth = 3
        
    }
    
    private func setupPaging() {
        let tempSB = UIStoryboard(name: "TJTemp", bundle: nil)
        let tempVC = tempSB.instantiateViewController(withIdentifier: "TJTempViewController")
        
        dataSource = [(title: "내정보", vc: tempVC)]
        
        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        
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
            contentViewController.delegate = self // <- set content delegate
        }
    }
    
    @IBAction func profilePhotoBtn(_ sender: UIButton) {
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
        contentViewController.scroll(to: page, animated: true)
    }
}

extension TJProfileViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
}
