//
//  GenreSelectViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import RxSwift
import RxRelay

final class SubscribeGenreViewModel: ViewModelType {
    
    var coordinator: Coordinator
    private var usecase: GenreUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: Coordinator, usecase: GenreUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        
    }
    
    struct Output {
        var genreList = BehaviorRelay<[GenreType]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        bindOutput(output)
        
        return output
    }
    
    private func bindOutput(_ output: Output) {
        self.usecase.genreList
            .map { $0.map { GenreType(rawValue: $0) }.compactMap { $0 } }
            .bind(to: output.genreList)
            .disposed(by: disposeBag)
    }
}
