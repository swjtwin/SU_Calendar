import SwiftUI

/// 커스텀캘린더 ViewModel
final class CustomCalendarVM: ObservableObject {
    // MARK: - init
    init() {
        self.getCurDate()
    }
    
    private var curYear: Int  = 0
    private var curMonth: Int = 0
    private let calendar = Calendar.autoupdatingCurrent // 해당 지역에 맞는 캘린더 가져오기
    
    // 현재일자
    private var currentDate: String = ""
    
    // MARK: - 옵션
    /// 요일언어 선택 ( 일,월,화 / S,M,T )
    private let weekLang: WeekLang = .en
    
    
    // MARK: - Published
    @Published var selectFirstIndex: String?
    @Published var selectEndIndex: String?
    
    // MARK: - 연산프로퍼티
    var startDate: String {
        if let selectFirstIndex {
            return self.formatDate(selectFirstIndex)
        } else {
            return ""
        }
    }
    
    var endDate: String {
        if let selectEndIndex {
            return self.formatDate(selectEndIndex)
        } else {
            return ""
        }
    }
    
    var weeks: [String] {
        switch weekLang {
        case .ko:
            return ["일","월","화","수","목","금","토"]
        case .en:
            return ["S","M","T","W","T","F","S"]
        }
    }
    
    // MARK: - 열거형
    /// 요일 언어
    enum WeekLang {
        case ko // 한국어
        case en // 영어
    }

    // MARK: - 내부 메서드
    /// 현재 년 월 가져오기
    private func getCurDate() {
        let today = self.calendar.dateComponents([.year,.month,.day], from: Date())
        self.curYear = today.year ?? 2023
        self.curMonth = today.month ?? 1
        let day = today.day ?? 1
        currentDate = "\(curYear)\(String(format: "%02d", curMonth))\(String(format: "%02d", day))"
        print("오늘 일자", currentDate)
//        print("\(curYear) \(curMonth) \(today.day)")
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy.MM.dd E"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate.uppercased()
        } else {
            return ""
        }
    }
    
    // MARK: - 메서드
    /// 달력 선택일자 Text
    func selectText(_ dayText: String) -> String {
        if selectFirstIndex == dayText {
            return "시작일"
        } else if selectEndIndex == dayText {
            return "종료일"
        } else {
            return ""
        }
        
    }
    
    /// 달력 선택일자 색상변경
    func selectColor(_ index: String) -> Color {
        if self.selectFirstIndex != index, self.selectEndIndex != index {
            return Color.clear
        } else {
            return Color.customBlue
        }
    }
    
    /// 달력 선택일자 색상변경
    func selectFontColor(_ dayText: String, day: Int) -> Color {
        if self.selectFirstIndex != dayText, self.selectEndIndex != dayText {
            if day % 7 == 1 {
                return Color.red
            } else {
                return Color.black
            }
        } else {
            return Color.white
        }
    }
    
    /// onTapGesture시 시작일, 종료일 선택되게.
    func selectDay(_ dayText: String) {
        // 시작, 종료가 다 지정된 상태에서 한번 더 누르면.
        if selectFirstIndex != nil, selectEndIndex != nil {
            selectFirstIndex = dayText
            selectEndIndex   = nil
            
        } else if selectFirstIndex != nil, selectEndIndex == nil {
            // 종료일 선택 시점에 이미 선택되어있는 시작일보다 더 늦은 위치로 가면 시작일과 종료일을 서로 바꿔준다.
            if let firstNum = Int(selectFirstIndex!), let endNum = Int(dayText) {
//                print("first : \(firstNum) end : \(endNum)")
                if firstNum < endNum {
                    selectEndIndex = dayText
                } else {
                    selectEndIndex = selectFirstIndex
                    selectFirstIndex = dayText
                }
            }
            
            // 선택된 시작일과 종료일이 같으면 종료일은 빼준다.
            if selectFirstIndex == selectEndIndex {
                selectEndIndex = nil
            }
            
        } else {
            selectFirstIndex = dayText
            
        }
    }
    
    /// 선택한 날짜인지 Bool 반환메서드
    func isSelected(_ dayText: String) -> Bool {
        guard let selectFirstIndex, let selectEndIndex else { return false }
        if selectFirstIndex == dayText || selectEndIndex == dayText {
            return true
        } else {
            return false
        }
    }
    
    /// 오늘 날짜인지 Bool 반환메서드
    func isToday(_ dayText: String) -> Bool {
        guard !self.currentDate.isEmpty else { return false }
        if dayText == self.currentDate {
            return true
        } else {
            return false
        }
    }
    
    
    /// 시작일과 종료일 사이의 일자인지 여부
    func isBetweenDay(_ dayText: String) -> Bool {
        guard let selectFirstIndex, let selectEndIndex else { return false }
        
//        let dayTextNum = Int(dayText) ?? 0
//        let firstIndexNum = Int(selectFirstIndex) ?? 0
//        let endIndexNum = Int(selectEndIndex) ?? 0
        
        if selectFirstIndex <= dayText, selectEndIndex >= dayText {
            return true
        } else {
            return false
        }
        
    }
    
    /// 처음선택과 끝 선택의 offSet 조절하기
    func firstEndoffSet(_ dayText: String) -> CGFloat {
        guard let selectFirstIndex, let selectEndIndex else { return 0 }
        
        if selectFirstIndex == dayText {
            return 15
        } else if selectEndIndex == dayText {
            return -15
        } else {
            return 0
        }
    }
    
    // 오늘 위치로 스크롤
    func scrollToday(_ proxy: ScrollViewProxy) {
        proxy.scrollTo(0, anchor: .bottom)
    }
        
    /// index 월만큼 다음달
    func plusDate(_ index: Int) -> (Int, Int) {
        var curDateComponent: DateComponents = .init()
        curDateComponent.year  = self.curYear
        curDateComponent.month = self.curMonth
        curDateComponent.day   = 1
        
        var newDate = self.calendar.date(from: curDateComponent) ?? Date()
        newDate = self.calendar.date(byAdding: DateComponents(month: index), to: newDate) ?? Date()
        
        let newComponent = self.calendar.dateComponents([.year, .month], from: newDate)
        let nextYear  = newComponent.year!
        let nextMonth = newComponent.month!
        
        return (nextYear, nextMonth)
    }
    
    /// index 월만큼 이전달
    func minusDate(_ index: Int) -> (Int, Int) {
        var curDateComponent: DateComponents = .init()
        curDateComponent.year  = self.curYear
        curDateComponent.month = self.curMonth
        curDateComponent.day   = 1
        
        var newDate = self.calendar.date(from: curDateComponent) ?? Date()
        newDate = self.calendar.date(byAdding: DateComponents(month: -index), to: newDate) ?? Date()
        
        let newComponent = self.calendar.dateComponents([.year, .month], from: newDate)
        let befYear  = newComponent.year!
        let befMonth = newComponent.month!
        
        return (befYear, befMonth)
    }
    
    
}
