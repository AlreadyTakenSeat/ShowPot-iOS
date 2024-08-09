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
    }
    
    struct Input {
        let didTapBottomButton: PublishSubject<GenreActionType>
    }
    
    struct Output {
        var genreList = BehaviorRelay<[GenreState]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        
        input.didTapBottomButton.subscribe { action in
            switch action {
            case .addSubscribe:
                LogHelper.debug("구독 추가")
            case .deleteSubscribe:
                LogHelper.debug("구독 취소")
            }
        }
        .disposed(by: disposeBag)
        
        let output = Output()
        
        self.usecase.genreList
            .bind(to: output.genreList)
            .disposed(by: disposeBag)
        
        return output
    }
}
