//
//  PopView.swift
//  FinalPopView


import UIKit

class PopView: UIView {
    
    // MARK: IBOutlet
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IBAction
    @IBAction func addPostButton(_ sender: Any) {
//        self.present()
    }
    
    // MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


