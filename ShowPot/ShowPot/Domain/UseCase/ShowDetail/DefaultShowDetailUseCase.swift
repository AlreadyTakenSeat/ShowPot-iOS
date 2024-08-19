//
//  DefaultShowDetailUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/15/24.
//

import RxSwift

class DefaultShowDetailUseCase: ShowDetailUseCase {
    
    var ticketList = BehaviorSubject<[String]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
        ticketList.onNext(["interpark", "yes24", "melonticket", "티켓링크"])
    }
}
