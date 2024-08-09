//
//  GenreSelectViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import RxSwift
import RxRelay

struct GenreState {
    let genre: GenreType
    let isSubscribed: Bool
}

final class SubscribeGenreViewModel: ViewModelType {
    
    var coordinator: Coordinator
    private var usecase: GenreUseCase
    private let disposeBag = DisposeBag()
    
    var isLoggedIn = true  // TODO: #6 API 구현 이후 수정
    
    init(coordinator: Coordinator, usecase: GenreUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.bind()
    }
    
    struct Input {
        let didTapAddSubscribeButton: PublishSubject<[GenreType]>
        let didTapDeleteSubscribeButton: PublishSubject<GenreType>
    }
    
    struct Output {
        var genreList = BehaviorRelay<[GenreState]>(value: [])
        var addSubscriptionResult = PublishSubject<Bool>()
        var deleteSubscriptionResult = PublishSubject<Bool>()
    }
    
    func transform(input: Input) -> Output {
        
        input.didTapAddSubscribeButton
            .subscribe(with: self) { owner, list in
                self.usecase.addSubscribtion(list: list)
            }.disposed(by: disposeBag)
        
        input.didTapDeleteSubscribeButton
            .subscribe(with: self) { owner, type in
                self.usecase.deleteSubscribtion(genre: type)
            }.disposed(by: disposeBag)
        
        let output = Output()
        
        usecase.genreList
            .bind(to: output.genreList)
            .disposed(by: disposeBag)
        
        usecase.addSubscribtionresult
            .bind(to: output.addSubscriptionResult)
            .disposed(by: disposeBag)
        
        usecase.deleteSubscribtionresult
            .bind(to: output.deleteSubscriptionResult)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SubscribeGenreViewModel {
    private func bind() {
        Observable.merge(usecase.addSubscribtionresult, usecase.deleteSubscribtionresult)
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestGenreList()
            }.disposed(by: disposeBag)
    }
}
