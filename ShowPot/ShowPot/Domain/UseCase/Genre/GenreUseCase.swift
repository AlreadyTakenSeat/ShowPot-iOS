//
//  GenreUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/7/24.
//

import RxSwift

protocol GenreUseCase {
    var genreList: BehaviorSubject<[GenreState]> { get set }
    var addSubscribtionresult: PublishSubject<Bool> { get set }
    var deleteSubscribtionresult: PublishSubject<Bool> { get set }
    
    func requestGenreList()
    func addSubscribtion(list: [GenreType])
    func deleteSubscribtion(genre: GenreType)
}
