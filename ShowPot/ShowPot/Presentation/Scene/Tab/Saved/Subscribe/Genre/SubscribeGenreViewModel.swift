//
//  GenreSelectViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import Foundation

final class SubscribeGenreViewModel: ViewModelType {
    
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
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

