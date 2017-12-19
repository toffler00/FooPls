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
    
    // MARK: 팝업뷰 세팅
    public func setUpPopUpView() {
        // 팝업뷰 생성
        let viewColor = UIColor.black
        // 부모뷰 투명
        popUpView.backgroundColor = viewColor.withAlphaComponent(0.3)
        popUpView.frame = self.view.bounds // 팝업 뷰를 화면에 맞게
        // 팝업창 배경색
        let baseViewColor = #colorLiteral(red: 1, green: 0.9967653155, blue: 0.9591305852, alpha: 1)
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
            tableView.separatorStyle = .none
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath)
            if let cell = cell as? PostCell {
                let text = contentTitleList[indexPath.row]
                cell.postLB.text = text
                //                tableView.separatorStyle = .singleLine
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
        let index = indexPath.row
        print("contentKeys: ", self.contentKeys)
        print("titleList: ", self.contentTitleList)
        // 델리게이트를 이용해서 넘길 예정
        let testTitle = contentTitleList[index]
        postDelegate?.selectedPostCellData(controller: self, data: testTitle)
        let detailSB = UIStoryboard(name: "TJDetailTimeline", bundle: nil)
        let detailVC = detailSB.instantiateViewController(withIdentifier: "TJDetail") as! TJDetailTimelineViewController
        detailVC.selectedKey = self.contentKeys[index]
        present(detailVC, animated: true, completion: nil)
        
    }
    // MARK: ios 11부터 셀 삭제
    @available (iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var swipeActionsConfigure = UISwipeActionsConfiguration()
        switch contentTitleList.count {
        case 0:
            break // ToDo
        default:
            let indexPathRow = indexPath.row
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                guard let `self` = self else { return }
                success(true)
                //                self.removeObjectFromFireBase()
                
            }
            swipeActionsConfigure = UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return swipeActionsConfigure
    }
    
    func removeObjectFromFireBase() {
        guard let uid = userID else { return }
//                let removeObjectRef = reference.child("users").child(uid).child("calendar").re
        let removeObjectRef = reference.observe(.childRemoved) { (snapshot) in
            reference.child("users").removeObserver(withHandle: <#T##UInt#>)
        }
//                removeObjectRef.removeValue()
    }
    
    // MARK: ios 11버전 미만 셀 삭제
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        let indexPathRow = indexPath.row
    //        if editingStyle == .delete {
    //            self.contentTitleList.remove(at: indexPathRow)
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //    }
}

// MARK: - EmptyCellDelegate
extension CalendarViewController: EmptyCellDelegate {
    // MARK: 빈셀의 버튼을 눌렀을 경우 글쓰기 VC로 이동
    internal func emptyCellButton(_ cell: EmptyCell) {
        print("\(#function)")
        self.performSegue(withIdentifier: "NewWrite", sender: self )
    }
    
}

// MARK: - PopViewDelegate
extension CalendarViewController: PopViewDelegate {
    
    // 포스팅버튼
    internal func postWritingButton(button: UIButton) {
        self.performSegue(withIdentifier: "NewWrite", sender: self )
    }
    // 선택한 날짜 레이블에 표시
    internal func popUpWritingDelegate(date: String) {
        popUpView.dateLB.text = date
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CalendarViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if popUpView.bounds.contains(touch.location(in: popUpView.baseView)){
            return false
        }
        return true
    }
}


