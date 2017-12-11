//
//  EmptyCell.swift
//  FinalPopView

import UIKit

class EmptyCell: UITableViewCell {
    
    @IBOutlet weak var writeButton: UIButton!
    weak var delegate: EmptyCellDelegate?
    
    // 글쓰기 부분으로 넘어가는 버튼
    @IBAction func postWriting(_ sender: UIButton) {
        delegate?.emptyCellButton(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 버튼 이미지 사이즈
        writeButton.imageEdgeInsets = UIEdgeInsetsMake(70, 70, 70, 50)
        // 버튼 원으로 만들기
//        writeButton.layer.cornerRadius = writeButton.frame.width/2
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
