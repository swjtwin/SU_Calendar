//
//  Extension.swift
//  GUIVING_SU
//
//  Created by woojin Shin on 2023/09/03.
//

import SwiftUI


extension Color {
    
    static var customBlue: Color {
        return .init(red: 45/255, green: 132/255, blue: 237/255)
    }
    
    static var lightGray: Color {
        return .init(red: 0.74, green: 0.74, blue: 0.74)
    }
    
    static var lightBlue: Color {
        return .init(red: 222/255, green: 234/255, blue: 250/255)
    }
    
    static var shadowGray: Color {
        return Color(red: 0.61, green: 0.61, blue: 0.61)
    }
    
    
}



extension Date {
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 M월 dd일 HH:mm"
        return formatter.string(from: self)
    }
}
