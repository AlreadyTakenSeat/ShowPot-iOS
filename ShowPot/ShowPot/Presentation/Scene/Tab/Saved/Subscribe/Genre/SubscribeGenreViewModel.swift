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
        let viewInit: Observable<Void>
    }
    
    struct Output {
        var genreList = BehaviorRelay<[String]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        
        input.viewInit.subscribe(with: self) { owner, _ in
            owner.usecase.requestGenreList()
        }
        .disposed(by: disposeBag)
        
        let output = Output()
        bindOutput(output)
        
        return output
    }
    
    private func bindOutput(_ output: Output) {
        self.usecase.genreList
            .bind(to: output.genreList)
            .disposed(by: disposeBag)
    }
}

extension SubscribeGenreViewModel {
    
    
}
