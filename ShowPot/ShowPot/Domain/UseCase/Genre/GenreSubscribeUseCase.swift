//
//  GenreSubscribeUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/7/24.
//

import RxSwift

final class GenreSubscribeUseCase: GenreUseCase {
    var genreList = BehaviorSubject<[GenreState]>(value: [])
    var addSubscribtionresult = PublishSubject<Bool>()
    var deleteSubscribtionresult = PublishSubject<Bool>()
    
    // MARK: Internal properties
    /// 전체 장르 리스트
    private var supportedGenreList = BehaviorSubject<[GenreType]>(value: [])
    /// 구독중인 장르 리스트
    private var subscribedGenreList = BehaviorSubject<[GenreType]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    func requestGenreList() {
        self.requestSupportedGenreList()
        self.requestSubscribedGenreList()
    }
    
    func addSubscribtion(list: [GenreType]) {
        // TODO: #6 장르 구독 추가 요청
        addSubscribtionresult.onNext([true, false].shuffled()[0])
    }
    
    func deleteSubscribtion(genre: GenreType) {
        // TODO: #6 장르 구독 삭제 요청
        deleteSubscribtionresult.onNext([true, false].shuffled()[0])
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
