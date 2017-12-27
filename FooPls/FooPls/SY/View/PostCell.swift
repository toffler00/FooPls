//
//  PostCell.swift
//  FinalPopView
import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postLB: UILabel!
}

// MARK: 프로토콜
protocol PostCellDelegate: class {
    func selectedPostCellData(controller: UIViewController, data: String)
}

