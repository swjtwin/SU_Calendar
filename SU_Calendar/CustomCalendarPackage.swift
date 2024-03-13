// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

#Preview {
    PlanCalendarView()
}

// 적용 예시
struct PlanCalendarView: View {
    @StateObject private var calendarVM: CustomCalendarVM = .init()
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .imageScale(.large)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.leading, 18)
                
                Text("My ltinerary")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 16))
                    .kerning(0.24)
            }
            .padding(.vertical, 19)
            
            VStack(spacing: 42) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("국가")
                            .foregroundStyle(Color.black)
                        HStack(spacing: 10) {
                            ForEach(1..<4) { index in
                                Button(action: {}, label: {
                                    Text("\(index) Nation")
                                })
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("도시")
                            .foregroundStyle(Color.black)
                        HStack(spacing: 10) {
                            ForEach(1..<4) { index in
                                Button(action: {}, label: {
                                    Text("\(index) City")
                                })
                            }
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // TODO: 달력 커스텀으로 다시 만들기
                // 상하 스크롤로 보여야 여행일정 짜는 캘린더의 목적에 어긋나지 않음.
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("일자 선택")
                        Spacer()
                        Text("\(calendarVM.startDate) \(calendarVM.endDate.isEmpty ? "" : "- \(calendarVM.endDate)")")
                            .foregroundStyle(Color.gray)
                    }
                    
                    CustomCalendarMain(vm: calendarVM, calBefCnt: 20, calNextCnt: 5)
                    
                }
                .overlay {
                    VStack {
                        Spacer()
                        Button(action: {}, label: {
                            Text("Done")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.pink)
                                }
                        })
                    }
                }
                
            }
            .padding()
            
        }
        .background(Color.white)
    }
}
