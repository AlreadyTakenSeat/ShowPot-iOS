//
//  DateFormatterFactory.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import Foundation
import Then

enum DateFormatterFactory {
    
    private static func dateFormatter(locale: SPLocale) -> DateFormatter {
        DateFormatter().then {
            $0.locale = Locale(identifier: locale.identifier)
        }
    }
    
    /// Showpot프로젝트 공연에 관련된 날짜 포맷
    static var dateWithPerformance: DateFormatter {
        dateFormatter(locale: .eng).then { $0.dateFormat = "MM.dd(EEE) HH:mm" }
    }
    
    /// `yyyy. MM. d`
    static var dateWithDot: DateFormatter {
        dateFormatter(locale: .eng).then { $0.dateFormat = "yyyy.MM.d" }
    }
    
    /// Showpot프로젝트 티켓팅에 관련된 날짜 포맷
    static var dateWithTicketing: DateFormatter {
        dateFormatter(locale: .kor).then { $0.dateFormat = "MM월 dd일 (EEE) HH:mm" }
    }
    
    /// `서버에서 내려주는 공통 날짜 포맷`
    static var dateTime: DateFormatter {
        dateFormatter(locale: .eng).then { $0.dateFormat = "yyyy-M-d HH:mm" }
    }
}

extension DateFormatterFactory {
    private enum SPLocale {
        case kor
        case eng
        
        var identifier: String {
            switch self {
            case .kor:
                return "ko_KR"
            case .eng:
                return "en_US"
            }
        }
    }
}
