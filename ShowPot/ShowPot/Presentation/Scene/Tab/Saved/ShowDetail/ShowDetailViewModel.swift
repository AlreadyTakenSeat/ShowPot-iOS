//
//  ShowDetailViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ShowDetailViewModel: ViewModelType {
    
    var coordinator: ShowDetailCoordinator
    private var usecase: ShowDetailUseCase
    private let disposeBag = DisposeBag()
    let showID: String
    
    init(showID: String, coordinator: ShowDetailCoordinator, usecase: ShowDetailUseCase) {
        self.showID = showID
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedLikeButton: Observable<Void>
        let didTappedBackButton: Observable<Void>
    }
    
    struct Output {
        var ticketList = BehaviorSubject<[String]>(value: [])
        var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
        var genreList = BehaviorSubject<[GenreType]>(value: [])
        var seatList = BehaviorSubject<[SeatDetailInfo]>(value: [])
        var isLikeButtonSelected = BehaviorSubject<Bool>(value: false)
        var alarmButtonState = BehaviorSubject<(isUpdatedBefore: Bool, isEnabled: Bool)>(value: (false, true))
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestShowDetailData(showID: owner.showID)
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
                
        let output = Output()
        
        input.didTappedLikeButton
            .subscribe(with: self) { owner, _ in
                owner.usecase.updateShowInterest()
            }
            .disposed(by: disposeBag)
        
        usecase.updateInterestResult
            .subscribe(with: self) { owner, isSuccess in
                LogHelper.debug("공연 관심 등록/취소 성공여부: \(isSuccess)")
                output.isLikeButtonSelected.onNext(isSuccess)
            }
            .disposed(by: disposeBag)
        
        usecase.buttonState
            .subscribe(with: self) { owner, state in
                LogHelper.debug("관심등록된 공연인가 ?: \(state.isLiked)\n이전에 알림설정한 공연인가 ?: \(state.isAlarmSet)")
                output.isLikeButtonSelected.onNext(state.isLiked)
                output.alarmButtonState.onNext((state.isAlarmSet, true))
            }
            .disposed(by: disposeBag)
        
        usecase.ticketList
            .bind(to: output.ticketList)
            .disposed(by: disposeBag)
        
        usecase.artistList
            .bind(to: output.artistList)
            .disposed(by: disposeBag)
        
        usecase.genreList
            .bind(to: output.genreList)
            .disposed(by: disposeBag)
        
        usecase.seatList
            .bind(to: output.seatList)
            .disposed(by: disposeBag)
        
        return output
    }
}
