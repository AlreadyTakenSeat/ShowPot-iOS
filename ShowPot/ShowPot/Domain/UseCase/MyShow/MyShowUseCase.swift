//
//  MyShowUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/11/24.
//

import Foundation

import RxSwift
import RxCocoa

protocol MyShowUseCase {
    
    var showList: BehaviorRelay<[PerformanceInfoCollectionViewCellModel]> { get }
    var ticketingAlarm: PublishRelay<[TicketingAlarmCellModel]> { get }
    var updateTicketingAlarmResult: PublishRelay<Bool> { get }
    
    func fetchShowList()
    func updateTicketingAlarm(model: [TicketingAlarmCellModel], showID: String)
    func deleteShowAlarm(indexPath: IndexPath)
    func requestTicketingAlarm()
}
