/*---------------------------------------------------------
 현재 스유로 만들어진 커스텀달력은 없는듯함.
 
 - 한 화면에 몇개(몇 달)까지 뿌리게 할건지도 옵션으로 지정.
 - 가로로 뿌릴지 세로로 뿌릴지도 지정. (스크롤 방향) -> CustomCalendarMain에서 분리 -> CustomCalendar 자체를 LazyHGrid로 만든걸 새로운 View로 하나 따로 만들고 분기처리해야할듯.
 - 일요일은 빨간색, 토요일은 파란색으로 가자. (이것도 옵션으로 지정가능하게) 옵션은 아직 안함. 23.10.28기준
 - 기준날짜(금일)에서 -3달, + 8달 ex) 5월이면 2월부터 내년 1월까지 (basic)
 ---------------------------------------------------------*/


import SwiftUI

/// 달력 - 단위(한달)
struct CustomCalendar: View {
    @ObservedObject var vm: CustomCalendarVM
    
    let year: Int
    let month: Int
    private let cells: [GridItem] = .init(repeating: .init(.flexible(), spacing: 0), count: 7)
    
    // MARK: - 연산프로퍼티
    /// 일자 범위
    private var daysRange: [String] {
        guard (1...12).contains(month) else { return [] }
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = 1
        
        let calendar = Calendar.autoupdatingCurrent
        
        guard let customDate = calendar.date(from: dateComponent) else { return [] }
        
        let newDate = calendar.dateComponents([.year,.month,.day,.weekday], from: customDate)
        let startWeekDay = newDate.weekday ?? 1
        let firstDayofMonth = calendar.date(from: newDate)!
        
        guard let range = calendar.range(of: .day, in: .month, for: firstDayofMonth) else { return [] }
        
        var returnDates: [String] = .init(repeating: "", count: startWeekDay - 1)
             
        for day in range {
            returnDates.append("\(year)\(String(format: "%02d", month))\(String(format: "%02d", day))")
        }
        
        return returnDates
    }
    
    // MARK: - View Body
    var body: some View {
        // ???: 뭔가를 보여주기만 하는게 아니라 해당 View에서 선택을 하거나 해야할때는 LazyVStack으로 하면 View가 뒤늦게 생성이 되는 경우가 있어서 좋지 않은듯 하다.
        VStack(alignment: .leading) {
            
            Section {
                Group {
                    // LazyVGrid의 spacing은 Vertical -> 위아래 간격을 조절한다.
                    LazyVGrid(columns: cells) {
                        ForEach(vm.weeks.indices, id: \.hashValue) { i in
                            let index = i + 1
                            Text("\(vm.weeks[i])")
                                .bold()
                                .foregroundColor(
                                    index % 7 == 1 ? Color.red : index % 7 == 0 ? Color.blue : Color.black
                                )
                        }
                    }
                    
                    LazyVGrid(columns: cells, alignment: .center, spacing: 15) {
                        
                        ForEach(daysRange.indices, id: \.hashValue) { index in
                            let day = index + 1
                            let dayText = daysRange[index]
                            
                            VStack {
                                GeometryReader { geo in
                                    Text(cutDay(dayText))
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(vm.selectFontColor(dayText, day: day))
                                        .background {
                                            Circle()
                                                .fill(vm.selectColor(dayText))
                                                .frame(height: geo.size.height * 3)
                                        }
                                        .background {
                                            Rectangle()
                                                .fill(Color.lightBlue)
                                                .frame(width: geo.size.width * (vm.isSelected(dayText) ? 0.5 : 1),
                                                       height: geo.size.height * 2.5)
                                                .offset(x: vm.firstEndoffSet(dayText))
                                                .opacity(vm.isBetweenDay(dayText) ? 1.0 : 0.0)
                                        }
                                }
                                
                                Text("오늘")
                                    .foregroundStyle(Color.blue)
                                    .opacity(vm.isToday(dayText) ? 1.0 : 0.0)
                                    .font(.caption2)
                                    .padding(.top, 8)
                                
                            }
                            .onTapGesture {
                                vm.selectDay(dayText)
                            }
                        }
                        
                    }
                    
                }
            } header: {
                HStack {
                    Text("\(year.description).\(String(format: "%02d", month))")
                        .foregroundStyle(Color.black)
                        .font(.system(size: 14))
                    
                    
                    Spacer()
//                    Button(action: {
//
//                    }, label: {
//                        Text("Today")
//                            .foregroundStyle(Color.primary)
//                    })
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                
            }
            
        }
        .background(Color.white)
    }
    
    // MARK: - 내부 메서드
    /// yyyymmdd 형식의 date를 dd만 남기고 자르기
    private func cutDay(_ input: String) -> String {
        guard !input.isEmpty else { return "" }
        
        var output: String
        
        output = String(input.suffix(2))
        
        // 끝숫자가 1자리 숫자일경우 한번더 잘라준다.
        if let temp = Int(output) {
            if String(temp).count <= 1 {
                output = String(output.suffix(1))
            }
        }
        
        return output
    }
    
}
