
import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController {
    
    // 사용자 정의 팝업
    let popUpView: PopView = UINib(nibName: "View", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PopView
    
    
    var reference: DatabaseReference!
    var userID: String!
    let formater = DateFormatter()
    var oldDate: String = ""
    var selectedDate: String?
    var contentArray: [String] = []
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearMonthLb: UILabel!
    //MARK: - 셀의 내부의 텍스트와 선택 됐을 때의 뷰를 색 지정
    let outsideMonthColor = UIColor(red: 88.0/255.0, green: 74.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    let monthColor = UIColor.black
    let selectedMonthColor = UIColor(red: 58.0/255.0, green: 41.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    let currentDateSelectedViewColor = UIColor(red: 78.0/255.0, green: 63.0/255.0, blue: 93.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = Database.database().reference()
        userID = Auth.auth().currentUser?.uid
        setupCalendar()
        loadDate()
    }
    
    private func loadDate() {
        reference.child("users").child(userID!).child("calendar").observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String : [String: Any]] {
                for (key, calendarDic) in value {
                    print(key)
                    self.contentArray.append(key)
                    self.calendarView.reloadData()
                }
            }
        }
    }
    
    //MARK: - 처음 뷰가 불렸을 때 캘린더 셋팅
    private func setupCalendar() {
        //날짜 cell들의 간격
        calendarView.minimumLineSpacing = 0.5
        calendarView.minimumInteritemSpacing = 0
        //로드 될때 현재의 년, 월을 레이블에 나타내기 위해
        calendarView.visibleDates { (segInfo) in
            let date = segInfo.monthDates.first!.date
            
            self.formater.dateFormat = "yyyy년 MM월"
            self.yearMonthLb.text = self.formater.string(from: date)
        }
    }
    
    //MARK: - 보이는 날의 정보를 보여 주기 위한 메소드
    private func setupViewCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formater.dateFormat = "yyyy년 MM월"
        self.yearMonthLb.text = self.formater.string(from: date)
    }
    
    //셀이 선택 되었을 때 텍스트 색을 정해주기 위한 메소드
    private func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        if validCell.isSelected {
            validCell.calendarLb.textColor = selectedMonthColor
        }else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.calendarLb.textColor = monthColor
            }else {
                validCell.calendarLb.textColor = outsideMonthColor
            }
        }
    }
    
    //MARK: - 셀이 선택 되었을 때 셀의 선택 뷰를 표현하기 위한 메소드
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        }else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellisContents(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        formater.dateFormat = "yyyy년 MM월 dd일"
        let thisMonthContents = formater.string(from: cellState.date)
        if contentArray.contains(thisMonthContents) {
            validCell.isContentImgView.isHidden = false
        }else {
            validCell.isContentImgView.isHidden = true
        }
    }
    
    //MARK: - Segue
    //선택된 데이터를 넘기기 위한 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewWrite" {
            let destinationController = segue.destination as! NewWriteViewController
            destinationController.selectedDate = selectedDate!
        }
    }
    
    @IBAction func writeBtnAction(_ sender: UIButton) {
        if selectedDate != nil {
            performSegue(withIdentifier: "NewWrite", sender: self)
        }else {
            let alertSheet = UIAlertController(title: "날짜 선택", message: "날짜를 선택해주세요", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertSheet.addAction(okAction)
            present(alertSheet, animated: true, completion: nil)
            return
            
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate{
    //MARK: - 셀이 선택 되었을 때 불림
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        formater.dateFormat = "yyyy년 MM월 dd일"
        selectedDate = formater.string(from: date)
        if oldDate == selectedDate {
            print("같은 날짜가 찍혔습니다.", selectedDate!, oldDate)
            performSegue(withIdentifier: "TJ_Temp", sender: self)
        }else {
            oldDate = selectedDate!
        }
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    //MARK: - 셀의 선택이 풀렸을 때 불리는 함수
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    //MARK: - 아직은 잘 모름
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    //MARK: - 스크롤 했을 때 보이는 날짜정보를 업데이트 하기 위한 메소드 (스크롤을 했을 때 불림)
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewCalendar(from: visibleDates)
    }

    //MARK: - 셀을 재사용할 때 셀의 상태와 셀의 정보를 읽기 위한 메소드
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.calendarLb.text = cellState.text
        handleCellisContents(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        
        return cell
    }
    
    @IBAction func unwindeSegue(_ sender: UIStoryboardSegue) {
        
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    //MARK: - 캘린더의 설정 (캘린더의 시작과 끝의 날짜를 지정)
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formater.dateFormat = "yyyy MM dd"
        formater.timeZone = Calendar.current.timeZone
        formater.locale = Calendar.current.locale
        
        let startDate = formater.date(from: "2017 01 01")!
        let endDate = formater.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }
}
