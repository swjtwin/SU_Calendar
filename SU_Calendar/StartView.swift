//
//  StartView.swift
//  SU_Calendar
//
//  Created by woojin Shin on 3/13/24.
//

import SwiftUI

struct StartView: View {
    @StateObject private var customVM = CustomCalendarVM()
    var body: some View {
        CustomCalendarMain(vm: customVM)
        .padding()
    }
}

#Preview {
    StartView()
}
