//
//  PopView.swift
//  FinalPopView


import UIKit

class PopView: UIView {
    
    weak var popViewDelegate: PopViewDelegate?
    
    // MARK: IBOutlet
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var baseSuperView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IBAction
    @IBAction func addPostButton(_ sender: UIButton) {
        self.popViewDelegate?.postWritingButton(button: sender)
    }
    
    // MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        setPopUpViewContents()

    }
    // MARK: 팝뷰 컨텐츠 세팅
    private func setPopUpViewContents() {
        // baseView cornerRadius
        self.baseView.layer.cornerRadius = 10
        // baseView에 있는 UIView cornerRadius
        for content in self.baseView.subviews {
            content.layer.cornerRadius = 10
        }
        // 추가 버튼 색상변경
        // withRenderingMode - alwaysTemplate:
        // 항상 색상 정보를 무시하고 템플릿 이미지로 그림
        let add = UIImage(named: "plus.png")?.withRenderingMode(.alwaysTemplate)
        self.addButton.setImage(add, for: .normal)
        self.addButton.tintColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        self.addButton.contentMode = .scaleAspectFit
        self.addButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
    }
}

protocol PopViewDelegate: class {
    func popUpWritingDelegate(date: String)
    func postWritingButton(button: UIButton)
}


