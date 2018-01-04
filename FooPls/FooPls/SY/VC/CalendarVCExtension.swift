//
//  CalendarVCExtension.swift
//  FooPls

import UIKit

// PostCell의 xib 파일명, cell ID
let postCell = "PostCell"
// EmptyCell의 xib 파일명, cell ID
let emptyCell = "EmptyCell"

// MARK: - CalendarViewController extension
extension CalendarViewController {
    
    // MARK: 팝업뷰
    public func setUpPopUpView() {
        configurePopView()
        popUpView.tableView.delegate = self
        popUpView.tableView.dataSource = self
        popUpView.popViewDelegate = self
        popUpView.tableView.tableFooterView = UIView(frame: .zero)
        popUpView.tableView.register(UINib.init(nibName: postCell, bundle: nil), forCellReuseIdentifier: postCell)
        popUpView.tableView.register(UINib.init(nibName: emptyCell, bundle: nil), forCellReuseIdentifier: emptyCell)
        self.view.addSubview(popUpView)
    }
    // MARK: 팝업뷰 기본 틀 세팅
    private func configurePopView() {
        // 팝업뷰 생성
        let viewColor = UIColor.black
        // 부모뷰 투명
        popUpView.backgroundColor = viewColor.withAlphaComponent(0.3)
        popUpView.frame = self.view.bounds // 팝업 뷰를 화면에 맞게
        // 팝업창 배경색
        let baseViewColor = #colorLiteral(red: 1, green: 0.9967653155, blue: 0.9591305852, alpha: 1)
        // 팝업 배경
        popUpView.baseView.backgroundColor = baseViewColor.withAlphaComponent(0.8)
    }
    // MARK: 파이어베이스에서 데이터삭제 함수
    fileprivate func removeDatabase( _ tableView: UITableView, _ indexPath: IndexPath) {
        guard let uid = self.userID else { return }
        self.reference.child("users").child(uid).child("calendar")
            .child(self.contentKeys[indexPath.item]).removeValue()
        self.reference.observe(.childRemoved) { (snapshot) in
            let indexPathRow = indexPath.row
            self.contentKeys.remove(at: indexPathRow)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    // MARK: 데이터 개수에 따른 테이블 뷰 row 생성
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = contentTitleList.count
        return (count > 0) ? count : 1
    }
    // MARK: 데이터 개수에 따라 사용하는 cell다름
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentTitleList.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCell, for: indexPath) as! EmptyCell
            tableView.bounces = false
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath)
            tableView.bounces = true
            if let cell = cell as? PostCell {
                let text = contentTitleList[indexPath.row]
                cell.postLB.text = text
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    // MARK: 테이블 뷰 컨텐츠에 따라서 row 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch contentTitleList.count {
        case 0:
            return tableView.bounds.size.height
        default:
            return 50
        }
    }
    // MARK: 셀 선택했을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentTitleList.count {
        case 0:
            break
        default:
            let index = indexPath.row
            let testTitle = contentTitleList[index]
            postDelegate?.selectedPostCellData(controller: self, data: testTitle)
            let detailSB = UIStoryboard(name: "TJDetailTimeline", bundle: nil)
            let detailVC = detailSB.instantiateViewController(withIdentifier: "TJDetail") as! TJDetailTimelineViewController
            detailVC.selectedKey = self.contentKeys[index]
            present(detailVC, animated: true, completion: nil)
        }
    }
    // MARK: ios 11부터 셀 삭제
    @available (iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var swipeActionsConfigure = UISwipeActionsConfiguration()
        switch contentTitleList.count {
        case 0:
            break
        default:
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                guard let `self` = self else { return }
                success(true)
                self.removeDatabase(tableView, indexPath)
            }
            swipeActionsConfigure = UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return swipeActionsConfigure
    }
    // MARK: ios 11버전 이전 셀 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeDatabase(tableView, indexPath)
        }
    }
}
// MARK: - EmptyCellDelegate
extension CalendarViewController: EmptyCellDelegate {
    // MARK: 빈셀의 버튼을 눌렀을 경우 글쓰기 VC로 이동
    func emptyCellButton(_ cell: EmptyCell) {
        self.performSegue(withIdentifier: "NewWrite", sender: self )
    }
}
// MARK: - PopViewDelegate
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
// MARK: - UIGestureRecognizerDelegate
extension CalendarViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if popUpView.baseView.frame.contains(touch.location(in: popUpView)){ return false }
        return true
    }
}
