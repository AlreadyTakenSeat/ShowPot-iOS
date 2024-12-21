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
    case yes24 = "YES24"
    case interpark = "인터파크"
    case melonticket = "멜론티켓"
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

struct ShowDetailOverView {
    let posterImageURLString: String
    let title: String
    let time: Date?
    let location: String
}

struct SeatDetailInfo {
    let seatCategoryTitle: String
    let seatPrice: NSNumber?
}

struct ShowDetailButtonState {
    let isLiked: Bool
    let isAlarmSet: Bool
    let isAlreadyOpen: Bool
}

struct ShowDetailTicketInfo {
    let ticketCategory: [TicketInfo]
    let prereserveOpenTime: Date?
    let normalreserveOpenTime: Date?
}

struct TicketInfo {
    let categoryName: String
    let link: String
}

protocol ShowDetailUseCase {
    var showOverview: BehaviorSubject<ShowDetailOverView> { get set }
    var ticketModel: BehaviorSubject<ShowDetailTicketInfo> { get set }
    var artistModel: BehaviorSubject<[FeaturedSubscribeArtistCellModel]> { get set }
    var genreModel: BehaviorRelay<[GenreType]> { get set }
    var seatModel: BehaviorRelay<[SeatDetailInfo]> { get set }
    var buttonState: BehaviorRelay<ShowDetailButtonState> { get set }
    var updatedShowInterestResult: PublishSubject<Bool> { get set }
    
    func requestShowDetailData(showID: String)
    func updateShowInterest(showID: String)
    func deleteShowInterest(showID: String)
}
