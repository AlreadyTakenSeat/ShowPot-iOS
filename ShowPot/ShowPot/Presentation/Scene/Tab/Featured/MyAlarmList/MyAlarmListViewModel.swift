//
//  MyAlarmListViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 9/23/24.
//

import Foundation

final class MyAlarmListViewModel: ViewModelType {

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
