//
//  GenreSubscribeUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/7/24.
//

import RxSwift

final class GenreSubscribeUseCase: GenreUseCase {
    var genreList = BehaviorSubject<[String]>(value: [])
    
    func requestGenreList() {
        genreList.onNext(["rock", "band", "edm", "classic", "hiphop", "house", "opera", "pop", "rnb", "musical", "metal", "jpop", "jazz"])
    }
    
    init() {
        self.requestGenreList()
    }
}
