//
//  ShowDetail.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/15/24.
//

import RxSwift
import UIKit

enum TicketSaleBrand: String {
    case yes24
    case interpark
    case melonticket
    case other
    
    var title: String? {
        switch self {
        case .yes24:
            return "YES24"
        case .interpark:
            return "인터파크"
        case .melonticket:
            return "멜론티켓"
        case .other:
            return nil
        }
    }
    
    var color: UIColor {
        switch self {
        case .yes24:
            return .chipYes24
        case .interpark:
            return .chipInterpark
        case .melonticket:
            return .chipMelonticket
        case .other:
            return .chipDefault
        }
    }
}

protocol ShowDetailUseCase {
    var ticketList: BehaviorSubject<[String]> { get set }
    var artistList: BehaviorSubject<[FeaturedSubscribeArtistCellModel]> { get set }
    
    func requestShowDetailData()
}
