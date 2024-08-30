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
    
    var coordinator: SubscribeGenreCoordinator
    private var usecase: GenreUseCase
    private let disposeBag = DisposeBag()
    
    var isLoggedIn: Bool {
        LoginState.current == .loggedIn
    } 
    private var selectedGenre = Set<GenreType>()
    
    init(coordinator: SubscribeGenreCoordinator, usecase: GenreUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.bind()
    }
    
    struct Input {
        let didSelectGenreCell: PublishRelay<GenreState>
        let didTapAddSubscribeButton: Observable<Void>
        let didTapDeleteSubscribeButton: PublishRelay<GenreType>
        let didTapBackButton: Observable<Void>
    }
    
    struct Output {
        /// 장르 리스트 정보
        var genreList = BehaviorRelay<[GenreState]>(value: [])
        /// 구독 요청 활성화 여부 (하단 버튼 표출 여부)
        var subscribeAvailable = PublishRelay<Bool>()
        /// 구독 추가 요청 결과
        var addSubscriptionResult = PublishSubject<Bool>()
        /// 구독 취소 요청 결과
        var deleteSubscriptionResult = PublishSubject<Bool>()
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        
        input.didTapBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goBack()
            }.disposed(by: disposeBag)
        
        input.didSelectGenreCell
            .subscribe(with: self) { owner, model in
                if model.isSubscribed {
                    owner.selectedGenre.insert(model.genre)
                } else {
                    owner.selectedGenre.remove(model.genre)
                }
                
                Observable.just(owner.selectedGenre.isEmpty == false)
                    .bind(to: output.subscribeAvailable)
                    .disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
        input.didTapAddSubscribeButton
            .subscribe(with: self) { owner, _ in
                self.usecase.addSubscribtion(list: Array(owner.selectedGenre))
                
                Observable.just(false)
                    .bind(to: output.subscribeAvailable)
                    .disposed(by: owner.disposeBag)
                
            }.disposed(by: disposeBag)
        
        input.didTapDeleteSubscribeButton
            .subscribe(with: self) { owner, type in
                self.usecase.deleteSubscribtion(genre: type)
                
                Observable.just(false)
                    .bind(to: output.subscribeAvailable)
                    .disposed(by: owner.disposeBag)

            }.disposed(by: disposeBag)
        
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
