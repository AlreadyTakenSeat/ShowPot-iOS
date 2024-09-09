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
        let didTappedLikeButton: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedTicketingCell: Observable<IndexPath>
    }
    
    struct Output {
        var showOverview = BehaviorSubject<ShowDetailOverView>(value: .init(posterImageURLString: "", title: "", time: nil, location: ""))
        var ticketTimeInfo = BehaviorSubject<(Date?, Date?)>(value: (nil, nil))
        var ticketBrandList = BehaviorSubject<[String]>(value: [])
        var artistList = BehaviorSubject<[FeaturedSubscribeArtistCellModel]>(value: [])
        var genreList = BehaviorSubject<[GenreType]>(value: [])
        var seatList = BehaviorSubject<[SeatDetailInfo]>(value: [])
        var isLikeButtonSelected = BehaviorSubject<Bool>(value: false)
        var alarmButtonState = BehaviorSubject<(isUpdatedBefore: Bool, isEnabled: Bool)>(value: (false, true))
        var showLoginBottomSheet = PublishSubject<Void>()
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        
        input.didTappedTicketingCell
            .withLatestFrom(usecase.ticketList) { ($0, $1) }
            .subscribe(with: self) { owner, result in
                let (indexPath, ticketList) = result
                owner.coordinator.goToTicketingWebPage(link: ticketList.ticketCategory[indexPath.row].link)
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedLikeButton
            .subscribe(with: self) { owner, _ in
                guard owner.isLoggedIn else {
                    output.showLoginBottomSheet.onNext(())
                    return
                }
                owner.usecase.updateShowInterest(showID: owner.showID)
            }
            .disposed(by: disposeBag)
        
        usecase.showOverview
            .bind(to: output.showOverview)
            .disposed(by: disposeBag)
        
        usecase.updateInterestResult
            .subscribe(with: self) { owner, result in
                LogHelper.debug("공연 관심 등록/취소 여부: \(result)")
                output.isLikeButtonSelected.onNext(result)
            }
            .disposed(by: disposeBag)
        
        usecase.buttonState
            .subscribe(with: self) { owner, state in
                LogHelper.debug("관심등록된 공연인가 ?: \(state.isLiked)\n이전에 알림설정한 공연인가 ?: \(state.isAlarmSet)\n 이미 오픈된 공연인가: \(state.isAlreadyOpen)")
                output.isLikeButtonSelected.onNext(state.isLiked)
                output.alarmButtonState.onNext((state.isAlarmSet, state.isAlreadyOpen))
            }
            .disposed(by: disposeBag)
        
        usecase.ticketList
            .subscribe(with: self) { owner, model in
                output.ticketBrandList.onNext(model.ticketCategory.map { $0.categoryName })
                output.ticketTimeInfo.onNext((model.prereserveOpenTime, model.normalreserveOpenTime))
            }
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
    
    func requestShowDetailData() {
        usecase.requestShowDetailData(showID: self.showID)
    }
}
