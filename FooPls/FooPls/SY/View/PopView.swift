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
    }
}

protocol PopViewDelegate: class {
    func popUpWritingDelegate(date: String)
    func postWritingButton(button: UIButton)
}
