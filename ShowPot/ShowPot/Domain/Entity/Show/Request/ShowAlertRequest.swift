//
//  ShowAlertRequest.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/30/24.
//

import Foundation

struct ShowAlertRequest: Codable {
    /// yyyy-MM-dd'T'HH:mm
    let alertTimes: String
    
    init(alertDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        self.alertTimes = dateFormatter.string(from: alertDate)
    }
}
