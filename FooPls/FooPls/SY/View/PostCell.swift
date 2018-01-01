//
//  PostCell.swift
//  FinalPopView
import UIKit

class PostCell: UITableViewCell {
    
    // MARK: IBOutlet
    @IBOutlet weak var postLB: UILabel!
    
}

// MARK: - protocol PostCellDelegate
protocol PostCellDelegate: class {
    func selectedPostCellData(controller: UIViewController, data: String)
}

