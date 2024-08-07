//
//  GenreUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/7/24.
//

import RxSwift

protocol GenreUseCase {
    var genreList: BehaviorSubject<[String]> { get set }
    
    func requestGenreList()
}
