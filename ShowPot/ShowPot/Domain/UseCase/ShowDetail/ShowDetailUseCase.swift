//
//  ShowDetail.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/15/24.
//

import RxSwift
import RxCocoa
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

struct SeatDetailInfo {
    let seatCategoryTitle: String
    let seatPrice: String
}

struct ShowDetailButtonState {
    let isLiked: Bool
    let isAlarmSet: Bool
}

protocol ShowDetailUseCase {
    var ticketList: BehaviorSubject<[String]> { get set }
    var artistList: BehaviorSubject<[FeaturedSubscribeArtistCellModel]> { get set }
    var genreList: BehaviorRelay<[GenreType]> { get set }
    var seatList: BehaviorRelay<[SeatDetailInfo]> { get set }
    var buttonState: BehaviorRelay<ShowDetailButtonState> { get set }
    var updateInterestResult: PublishSubject<Bool> { get set }
    
    func requestShowDetailData(showID: String)
    func updateShowInterest()
}
