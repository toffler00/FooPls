//
//  EmptyCell.swift
//  FinalPopView

import UIKit

class EmptyCell: UITableViewCell {
    // MARK: property
    weak var delegate: EmptyCellDelegate?
    
    // MARK: IBOutlet - configure button ui
    @IBOutlet weak var writeButton: UIButton!
    
    // MARK: IBAction - 글쓰기 부분으로 넘어가는 버튼
    @IBAction func postWriting(_ sender: UIButton) {
        delegate?.emptyCellButton(self)
    }
    // MARK: when cell loads
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureButton()
    }
    // MARK: configureButton
    private func configureButton() {
        // 버튼 이미지 사이즈
        writeButton.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 20)
        // 버튼 원으로 만들기
        writeButton.layer.cornerRadius = writeButton.frame.size.width / 2.6
    }
}

// MARK: - protocol EmptyCellDelegate
protocol EmptyCellDelegate: class {
    func emptyCellButton(_ cell: EmptyCell)
}
