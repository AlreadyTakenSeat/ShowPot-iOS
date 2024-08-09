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
    private var selectedGenre = Set<GenreType>()
    
    init(coordinator: Coordinator, usecase: GenreUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.bind()
    }
    
    struct Input {
        let didSelectGenreCell: PublishRelay<GenreState>
        let didTapAddSubscribeButton: Observable<Void>
        let didTapDeleteSubscribeButton: PublishRelay<GenreType>
    }
    
    struct Output {
        var bottomButtonHidden = BehaviorRelay<Bool>(value: false)
        var genreList = BehaviorRelay<[GenreState]>(value: [])
        var addSubscriptionResult = PublishSubject<Bool>()
        var deleteSubscriptionResult = PublishSubject<Bool>()
    }
    
    func transform(input: Input) -> Output {
        
        input.didSelectGenreCell
            .subscribe(with: self) { owner, model in
                if model.isSubscribed {
                    owner.selectedGenre.insert(model.genre)
                } else {
                    owner.selectedGenre.remove(model.genre)
                }
            }.disposed(by: disposeBag)
        
        input.didTapAddSubscribeButton
            .subscribe(with: self) { owner, _ in
                self.usecase.addSubscribtion(list: Array(owner.selectedGenre))
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
                owner.selectedGenre = Set<GenreType>()
                owner.usecase.requestGenreList()
            }.disposed(by: disposeBag)
    }
}
