
import UIKit

class GradientPostingView: UIViewController {
   
   
   
    let gradientView : UIImageView = {
        let gradientV = UIImageView()
        gradientV.backgroundColor = UIColor.clear
        return gradientV
    }()
    
    let writePostBtn : UIButton = {
        let postbtn = UIButton()
//        postbtn.addTarget(GradientPostingView.self, action: #selector(showPostingPage(_:)), for: UIControlEvents.touchUpInside)
        return postbtn
    }()
    
    let writeCallenderBtn : UIButton = {
        let callenbtn = UIButton()
        return callenbtn
    }()
    
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,
                                    height: self.view.frame.size.height)
        setGradientLayer()
        view.addSubview(gradientView)
        gradientView.layer.addSublayer(gradientLayer)
        btnLayout()
        
    }
    
    func setGradientLayer() {
        gradientLayer.frame = gradientView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        gradientLayer.colors = [
           UIColor(red: 0.98, green: 0.94, blue: 0.29, alpha: 0.9).cgColor,
           UIColor(red: 0.98, green: 0.94, blue: 0.29, alpha: 0.3).cgColor,
           UIColor(red: 0.98, green: 0.94, blue: 0.29, alpha: 0.0).cgColor
           
        ]
        gradientLayer.locations = [0.0 , 0.7 ,1.0]
    }
    
    @objc func showPostingPage(_ sender : Any) {
        print("확인")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension GradientPostingView {
    func btnLayout() {
        gradientView.addSubview(writePostBtn)
        let dx = self.view.frame.size.width / 8
        writePostBtn.frame = gradientView.bounds.offsetBy(dx: (self.view.frame.size.width - dx) / 2, dy: 480)
        writePostBtn.frame.size = CGSize(width: (self.view.frame.size.width) / 2, height: 56)
        
        writePostBtn.setTitle("리뷰 쓰기", for: UIControlState.normal)
        writePostBtn.titleLabel?.textColor = UIColor.white
        writePostBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        
    }
}
