//
//  EmptyCell.swift
//  FinalPopView

import UIKit

class EmptyCell: UITableViewCell {
    
    weak var delegate: EmptyCellDelegate?
    // configure button ui
    @IBOutlet weak var writeButton: UIButton!
    // 글쓰기 부분으로 넘어가는 버튼
    @IBAction func postWriting(_ sender: UIButton) {
        delegate?.emptyCellButton(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 버튼 이미지 사이즈
        writeButton.imageEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 15)
        // 버튼 원으로 만들기
        writeButton.layer.cornerRadius = writeButton.frame.width/2
    }
    
}

// 프로토콜
protocol EmptyCellDelegate: class {
    func emptyCellButton(_ cell: EmptyCell)
}
