//
//  AccountViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

final class AccountViewModel: ViewModelType {
    var coordinator: AccountCoordinator
    
    init(coordinator: AccountCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
