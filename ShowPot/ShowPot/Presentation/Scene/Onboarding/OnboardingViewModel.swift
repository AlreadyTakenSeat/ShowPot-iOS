//
//  OnboardingViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit
import RxSwift

final class OnboardingViewModel: ViewModelType {
    
    private var coordinator: OnboardingCoordinator
    private let disposeBag = DisposeBag()
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let didTapBottomButton: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didTapBottomButton.subscribe { [weak self] _ in
            self?.coordinator.dismiss()
        }.disposed(by: disposeBag)
        
        return Output()
    }
}
