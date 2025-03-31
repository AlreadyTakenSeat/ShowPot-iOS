//
//  DateStyle.swift
//  CoinCo
//
//  Created by 김도형 on 3/9/25.
//

import Foundation

enum DateStyle: String, CaseIterable {
    case showOpenData = "yyyy-M-d HH:mm"
    case showOpenEntity = "MM.dd(EEE) HH:mm"
    
    static var cachedFormatter: [DateStyle: DateFormatter] {
        var formatters = [DateStyle: DateFormatter]()
        for style in Self.allCases {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = style.rawValue
            formatters[style] = formatter
        }
        return formatters
    }
}

extension Date {
    func toString(
        _ style: DateStyle,
        identifier: String = "ko_KR"
    ) -> String {
        guard let formatter = DateStyle.cachedFormatter[style] else {
            return ""
        }
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(
        _ style: DateStyle,
        identifier: String = "ko_KR"
    ) -> Date? {
        guard let formatter = DateStyle.cachedFormatter[style] else {
            return nil
        }
        return formatter.date(from: self)
    }
}
