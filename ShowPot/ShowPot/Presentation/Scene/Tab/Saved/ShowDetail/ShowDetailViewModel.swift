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
    
    var isLoggedIn: Bool {
        LoginState.current == .loggedIn
    }
    
    init(showID: String, coordinator: ShowDetailCoordinator, usecase: ShowDetailUseCase) {
        self.showID = showID
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let didTappedLikeButton: Observable<UIButton.State>
        let didTappedBackButton: Observable<Void>
        let didTappedTicketingCell: Observable<IndexPath>
    }
    
    struct Output {
        var showOverview = BehaviorRelay<ShowDetailOverView>(value: .init(posterImageURLString: "", title: "", time: nil, location: ""))
        var ticketTimeInfo = BehaviorRelay<(Date?, Date?)>(value: (nil, nil))
        var ticketBrandModel = BehaviorRelay<[String]>(value: [])
        var artistModel = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
        var genreModel = BehaviorRelay<[GenreType]>(value: [])
        var seatModel = BehaviorRelay<[SeatDetailInfo]>(value: [])
        var isLikeButtonSelected = BehaviorRelay<Bool>(value: false)
        var alarmButtonState = BehaviorRelay<(isUpdatedBefore: Bool, isEnabled: Bool)>(value: (false, true))
        var showLoginBottomSheet = PublishRelay<Void>()
    }
    
    func transform(input: Input) -> Output {
        self.configureInput(input)
        return self.createOutput(from: input)
    }
    
    private func configureInput(_ input: Input) {
        input.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.usecase.requestShowDetailData(showID: owner.showID)
            }
            .disposed(by: disposeBag)
        
        input.didTappedTicketingCell
            .withLatestFrom(usecase.ticketModel) { ($0, $1) }
            .subscribe(with: self) { owner, result in
                let (indexPath, ticketModel) = result
                owner.coordinator.goToTicketingWebPage(link: ticketModel.ticketCategory[indexPath.row].link)
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
    }
    
    private func createOutput(from input: Input) -> Output {
        
        let output = Output()
        
        input.didTappedLikeButton
            .throttle(.milliseconds(500), latest: false, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .subscribe(with: self) { owner, state in
                guard owner.isLoggedIn else {
                    output.showLoginBottomSheet.accept(())
                    return
                }
                
                if state == .selected {
                    owner.usecase.deleteShowInterest(showID: owner.showID)
                } else {
                    owner.usecase.updateShowInterest(showID: owner.showID)
                }
                
            }
            .disposed(by: disposeBag)
        
        usecase.showOverview
            .bind(to: output.showOverview)
            .disposed(by: disposeBag)
        
        usecase.updatedShowInterestResult
            .bind(to: output.isLikeButtonSelected)
            .disposed(by: disposeBag)
        
        usecase.buttonState
            .subscribe(with: self) { owner, state in
                LogHelper.debug("관심등록된 공연인가 ?: \(state.isLiked)\n이전에 알림설정한 공연인가 ?: \(state.isAlarmSet)\n 이미 오픈된 공연인가: \(state.isAlreadyOpen)")
                output.isLikeButtonSelected.accept(state.isLiked)
                output.alarmButtonState.accept((state.isAlarmSet, state.isAlreadyOpen))
            }
            .disposed(by: disposeBag)
        
        usecase.ticketModel
            .subscribe(with: self) { owner, model in
                output.ticketBrandModel.accept(model.ticketCategory.map { $0.categoryName })
                output.ticketTimeInfo.accept((model.prereserveOpenTime, model.normalreserveOpenTime))
            }
            .disposed(by: disposeBag)
        
        usecase.artistModel
            .bind(to: output.artistModel)
            .disposed(by: disposeBag)
        
        usecase.genreModel
            .bind(to: output.genreModel)
            .disposed(by: disposeBag)
        
        usecase.seatModel
            .bind(to: output.seatModel)
            .disposed(by: disposeBag)
        
        return output
    }
}
