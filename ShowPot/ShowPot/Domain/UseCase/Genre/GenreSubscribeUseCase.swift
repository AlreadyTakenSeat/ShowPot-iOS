//
//  GenreSubscribeUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/7/24.
//

import RxSwift
import RxRelay

final class GenreSubscribeUseCase: GenreUseCase {
    
    private let genreAPI = SPGenreAPI()
    
    var genreList = BehaviorRelay<[GenreState]>(value: [])
    var addSubscribtionresult = PublishSubject<Bool>()
    var deleteSubscribtionresult = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.requestGenreList()
    }
    
    func addSubscribtion(list: [GenreType]) {
        genreAPI.subscribe(genreIDS: list.map { $0.id })
            .subscribe { response in
                self.addSubscribtionresult.onNext(true)
            } onError: { error in
                self.addSubscribtionresult.onNext(false)
            } onCompleted: { 
                self.requestGenreList()
            }
            .disposed(by: disposeBag)
    }
    
    func deleteSubscribtion(genre: GenreType) {
        genreAPI.unsubscribe(genreIDS: [genre].map { $0.id })
            .subscribe { response in
                self.deleteSubscribtionresult.onNext(true)
            } onError: { error in
                self.deleteSubscribtionresult.onNext(false)
            } onCompleted: {
                self.requestGenreList()
            }
            .disposed(by: disposeBag)
    }
    
    func requestGenreList() {
        genreAPI.genres()
            .map {
                $0.data.filter { GenreType(rawValue: $0.name) != nil }
                    .map {
                        GenreState(
                            genre: GenreType(rawValue: $0.name)!,
                            isSubscribed: $0.isSubscribed ?? false
                        )
                    }
            }
            .bind(to: self.genreList)
            .disposed(by: disposeBag)
    }
}
