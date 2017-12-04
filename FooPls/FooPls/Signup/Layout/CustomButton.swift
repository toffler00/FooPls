//
//  CustomButton.swift
//  FooPls

import UIKit

class CustomButton: UIButton {
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 3
    }
    
    // MARK: required Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 3
    }
}
// MARK: UIButton
extension UIButton {
    
    // MARK: 버튼레이어
    func buttonLayer(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}
