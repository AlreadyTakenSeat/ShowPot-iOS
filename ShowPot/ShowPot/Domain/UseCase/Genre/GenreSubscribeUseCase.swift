//
//  GenreSubscribeUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/7/24.
//

import RxSwift

final class GenreSubscribeUseCase: GenreUseCase {
    
    var genreList = BehaviorSubject<[GenreState]>(value: [])
    
    /// 전체 장르 리스트
    private var supportedGenreList = BehaviorSubject<[GenreType]>(value: [])
    /// 구독중인 장르 리스트
    private var subscribedGenreList = BehaviorSubject<[GenreType]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    func requestGenreList() {
        self.requestSupportedGenreList()
        self.requestSubscribedGenreList()
    }
    
    init() {
        Observable.zip(supportedGenreList, subscribedGenreList)
            .map { self.createGenreStateList($0, $1) }
            .bind(to: genreList)
            .disposed(by: disposeBag)
        
        self.requestGenreList()
    }
}

extension GenreSubscribeUseCase {
    
    private func requestSupportedGenreList() {
        let genreList = ["rock", "band", "edm", "classic", "hiphop", "house", "opera", "pop", "rnb", "musical", "metal", "jpop", "jazz"]
        supportedGenreList.onNext(genreList.compactMap { GenreType(rawValue: $0) })
    }
    
    private func requestSubscribedGenreList() {
        let subscribedList = ["rock", "band", "edm", "classic", "hiphop", "house", "opera", "pop", "rnb", "musical", "metal", "jpop", "jazz"].shuffled()
    
        subscribedGenreList.onNext(Array(subscribedList[0...5]).compactMap { GenreType(rawValue: $0) })
    }
}

extension GenreSubscribeUseCase {
    
    private func createGenreStateList(_ supported: [GenreType], _ subscribed: [GenreType]) -> [GenreState] {
        return supported.map { type in
            GenreState(genre: type, isSubscribed: subscribed.contains(type))
        }
    }
}
