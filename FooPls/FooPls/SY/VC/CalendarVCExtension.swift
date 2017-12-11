//
//  CalendarVCExtension.swift
//  FooPls

import UIKit

// PostCell의 xib 파일명, cell ID
let postCell = "PostCell"
// EmptyCell의 xib 파일명, cell ID
let emptyCell = "EmptyCell"

// MARK: CalendarViewController extension
extension CalendarViewController {

    // MARK: 팝업뷰 세팅
    func setUpPopUpView() {
        // 팝업뷰 생성
        let viewColor = UIColor.black
        // 부모뷰 투명
        popUpView.backgroundColor = viewColor.withAlphaComponent(0.3)
        popUpView.frame = self.view.bounds // 팝업 뷰를 화면에 맞게
        // 팝업창 배경색
        let baseViewColor = UIColor.white
        // 팝업 배경
        popUpView.baseView.backgroundColor = baseViewColor.withAlphaComponent(0.8)
        popUpView.tableView.delegate = self
        popUpView.tableView.dataSource = self
        popUpView.popViewDelegate = self
        popUpView.tableView.register(UINib.init(nibName: postCell, bundle: nil), forCellReuseIdentifier: postCell)
        popUpView.tableView.register(UINib.init(nibName: emptyCell, bundle: nil), forCellReuseIdentifier: emptyCell)
        self.view.addSubview(popUpView)
    }
}

// MARK: UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {

    // MARK: 데이터 개수에 따른 테이블 뷰 row 생성
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = testList.count
        return (count > 0) ? count : 1
    }

    // MARK: 데이터 개수에 따라 사용하는 cell다름
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch testList.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCell, for: indexPath) as! EmptyCell
            tableView.separatorStyle = .none
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath)
//            let index = indexPath.row
            if let cell = cell as? PostCell {
                cell.postDelegate = self
                let text = testList[indexPath.row]
                cell.postLB.text = text
            }
            return cell
        }

    }


}

// MARK: UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    // MARK: 테이블 뷰 컨텐츠에 따라서 row 높이 설정
    // 테이블 뷰의 셀 값이 유동적이게 해야하는데;;
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch testList.count {
        case 0:
            return tableView.bounds.size.height
        default:
            return 50
        }
    }
}

// MARK: EmptyCellDelegate
extension CalendarViewController: EmptyCellDelegate {
    // MARK: 빈셀의 버튼을 눌렀을 경우 글쓰기 VC로 이동
    func emptyCellButton(_ cell: EmptyCell) {
        print("\(#function)")
        self.performSegue(withIdentifier: "NewWrite", sender: self )
    }

}

// MARK: PostCellDelegate
extension CalendarViewController: PostCellDelegate {
    // MARK: PostList
    func postCellData(_ cell: PostCell) {
        
    }
}

// MARK: PopViewDelegate
extension CalendarViewController: PopViewDelegate {
    // 포스팅버튼
    func postWritingButton(button: UIButton) {
        self.performSegue(withIdentifier: "NewWrite", sender: self )
    }
    // 선택한 날짜 레이블에 표시
    func popUpWritingDelegate(date: String) {
        popUpView.dateLB.text = date
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension CalendarViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if popUpView.bounds.contains(touch.location(in: popUpView.baseView)){
            return false
        }
        return true
    }
}






