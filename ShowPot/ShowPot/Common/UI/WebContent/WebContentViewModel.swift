//
//  WebContentViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WebContentViewModel: ViewModelType {
    
    var coordinator: WebContentCoordinator
    private let disposeBag = DisposeBag()
    private let urlString: String
    
    init(urlString: String, coordinator: WebContentCoordinator) {
        self.coordinator = coordinator
        self.urlString = urlString
    }
    
    struct Input {
        let didTappedBackButton: Observable<Void>
    }
    
    struct Output {
        let webURL: Observable<URL>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        let webURL = Observable.just(urlString).compactMap { URL(string: $0) }
        return Output(webURL: webURL)
    }
}

