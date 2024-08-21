//
//  ShowDetailViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import RxSwift
import UIKit

final class ShowDetailViewModel: ViewModelType {
    
    var coordinator: ShowDetailCoordinator
    private var usecase: ShowDetailUseCase
    private let disposeBag = DisposeBag()
    
    var genreList: [GenreType] {
        usecase.genreList.value
    }
    
    init(coordinator: ShowDetailCoordinator, usecase: ShowDetailUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        var ticketList = BehaviorSubject<[String]>(value: [])
        var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
        var genreList = BehaviorSubject<[GenreType]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestShowDetailData()
            }
            .disposed(by: disposeBag)
        
        let output = Output()
        
        usecase.ticketList
            .bind(to: output.ticketList)
            .disposed(by: disposeBag)
        
        usecase.artistList
            .bind(to: output.artistList)
            .disposed(by: disposeBag)
        
        usecase.genreList
            .bind(to: output.genreList)
            .disposed(by: disposeBag)
        
        return output
    }
}
