//
//  EmptyCell.swift
//  FinalPopView
//
//  Created by SONGYEE SHIN on 2017. 12. 8..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    weak var delegate: EmptyCellDelegate?
    
    // 글쓰기 부분으로 넘어가는 버튼
    @IBOutlet weak var postWritingButton: UIButton!
    @IBAction func postWriting(_ sender: UIButton) {
        delegate?.emptyCellButton(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// 프로토콜
protocol EmptyCellDelegate: class {
    func emptyCellButton(_ cell: EmptyCell)
}
