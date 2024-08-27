//
//  GenreUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/7/24.
//

import RxSwift
import RxRelay

protocol GenreUseCase {
    var genreList: BehaviorRelay<[GenreState]> { get set }
    var addSubscribtionresult: PublishSubject<Bool> { get set }
    var deleteSubscribtionresult: PublishSubject<Bool> { get set }
    
    func requestGenreList()
    func addSubscribtion(list: [GenreType])
    func deleteSubscribtion(genre: GenreType)
}
