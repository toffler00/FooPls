
import UIKit

class GradientPostingView: UIViewController {
   
   
   
    let gradientView : UIImageView = {
        let gradientV = UIImageView()
        gradientV.backgroundColor = UIColor.clear
        return gradientV
    }()
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,
                                    height: self.view.frame.size.height)
        setGradientLayer()
        view.addSubview(gradientView)
        gradientView.layer.addSublayer(gradientLayer)
        
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
