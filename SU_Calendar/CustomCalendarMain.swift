//
//  CustomCalendarMain.swift
//
//
//  Created by woojin Shin on 3/13/24.
//

import SwiftUI

struct CustomCalendarMain: View {
    @ObservedObject var vm: CustomCalendarVM

    var calBefCnt: Int = 36 // 금일 기준으로 35달전까지(디폴트). 외부에서 값 받아옴. 오늘에 해당하는 년월은 계산에서 제외.
    var calNextCnt: Int = 15 // 금일 기준으로 14달 후까지(디폴트). 외부에서 값 받아옴.
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            ScrollView(.vertical) {
                Group {
                    // index : 0 => 금일기준의 년월
                    ForEach(Array(1..<calBefCnt).reversed(), id: \.hashValue) { index in
                        let (newYear, newMonth) = vm.minusDate(index)
                        CustomCalendar(vm: vm, year: newYear, month: newMonth)
                            .id(index)
                        
                    }
                    ForEach(0..<calNextCnt, id: \.hashValue) { index in
                        let (newYear, newMonth) = vm.plusDate(index)
                        CustomCalendar(vm: vm, year: newYear, month: newMonth)
                            .id(index)
                    }
                }
            }
            .background(Color.white) // 다크모드에 영향 안받게 하기위함.
            .onAppear {
                vm.scrollToday(proxy)
            }
        })
       
    }
}
