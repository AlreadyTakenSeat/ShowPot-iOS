//
//  Date+Extension.swift
//  ShowPot
//
//  Created by 이건준 on 8/12/24.
//

import Foundation

extension Date {
    /// 현재 시간으로부터 특정 시간 이상이 경과했는지 여부를 확인
    func hasElapsed(hours: Int) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // 현재 시간부터 이 날짜까지의 시간 차이를 계산
        let components = calendar.dateComponents([.hour], from: currentDate, to: self)
        
        // 경과 시간을 계산하고, 지정한 시간보다 큰지 확인
        guard let elapsedHours = components.hour else {
            return false
        }
        
        return elapsedHours >= hours
    }
    
    /// 주어진 목표일(`targetDate`)까지 남은 날짜를 반환합니다.
    func daysUntil(_ targetDate: Date) -> Int? {
        let calendar = Calendar.current
        
        // 두 날짜 사이의 일(day) 차이를 계산
        let components = calendar.dateComponents([.day], from: self, to: targetDate)
        
        guard let daysDifference = components.day else {
            return nil
        }
        
        return daysDifference
    }
}

extension String {
    
    func date(_ dateformat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformat
        
        return dateFormatter.date(from: self)
    }
    
}
