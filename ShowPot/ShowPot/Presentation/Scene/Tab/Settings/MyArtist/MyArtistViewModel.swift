//
//  MyArtistViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import Foundation

final class MyArtistViewModel: ViewModelType {
    
    var coordinator: MyArtistCoordinator
    
    init(coordinator: MyArtistCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        Output()
    }
}
