//
//  ShowDetailViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import RxSwift
import UIKit

final class ShowDetailViewModel: ViewModelType {
    
    var coordinator: ShowDetailCoordinator
    private var usecase: ShowDetailUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: ShowDetailCoordinator, usecase: ShowDetailUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        
    }
    
    struct Output {
        var ticketList = BehaviorSubject<[String]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        
        usecase.ticketList
            .bind(to: output.ticketList)
            .disposed(by: disposeBag)
        
        return output
    }
}
