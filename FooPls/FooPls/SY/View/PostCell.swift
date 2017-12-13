//
//  PostCell.swift
//  FinalPopView
import UIKit

class PostCell: UITableViewCell {

//    weak var postDelegate: PostCellDelegate?
    
    @IBOutlet weak var postLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//// MARK: 프로토콜
//protocol PostCellDelegate: class {
//    func postCellData(_ cell: PostCell)
//}

