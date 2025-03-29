//
//  NumberFormatterFactory.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import Foundation

enum NumberformatterFactory {
  private static var formatter: NumberFormatter {
    NumberFormatter().then {
      $0.locale = Locale(identifier: "ko_KR")
    }
  }
  
  static var decimal: NumberFormatter {
    formatter.then {
      $0.numberStyle = .decimal
    }
  }
}
