import UIKit

@IBDesignable
class CustomTextField : UITextField {
    
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if let image = leftImage{
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 25, height: 20))
                view.addSubview(imageView)
                leftView = view
            }else {
                leftViewMode = .never
            }
            
        }
    }
    
    @IBInspectable var placeholderColor : UIColor? {
        didSet {
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSAttributedStringKey.foregroundColor : placeholderColor!])
            attributedPlaceholder = str
        }
    }
    
    let bottomLayer = CALayer()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomLayer)
    }
    
    // MARK: required Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomLayer)
    }
    
    // MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scale = 1 / UIScreen.main.scale
        bottomLayer.frame = CGRect(x: 0, y: self.bounds.height - scale,
                                   width: self.bounds.width, height: scale)
    }
    
    // MARK: textRect
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 50, dy: 5)
    }
    
    // MARK: editingRexct
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 50, dy: 5)
    }
}

// MARK: UITextField
extension UITextField {
    
    // MARK: 텍스트필드 밑줄
    func addUnderLine(height:CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
