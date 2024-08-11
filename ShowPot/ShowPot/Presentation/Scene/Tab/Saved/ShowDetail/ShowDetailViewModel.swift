//
//  ShowDetailViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import Foundation

final class ShowDetailViewModel: ViewModelType {
    
    var coordinator: ShowDetailCoordinator
    
    init(coordinator: ShowDetailCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
