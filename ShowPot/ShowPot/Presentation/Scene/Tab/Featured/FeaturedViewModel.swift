//
//  FeaturedViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation

import RxSwift
import RxCocoa
import UIKit

final class FeaturedViewModel: ViewModelType {
    
    var coordinator: FeaturedCoordinator
    private let disposeBag = DisposeBag()
    
    private let usecase: SubscribeArtistUseCase & AllPerformanceUseCase
    
    private let subscribeGenreModelRelay = BehaviorRelay<[GenreType]>(value: [])
    private let recommendedPerformanceModelRelay = BehaviorRelay<[FeaturedRecommendedPerformanceCellModel]>(value: [])
    private let featuredSectionModelRelay = BehaviorRelay<[FeaturedSectionType]>(value: [])
    private let updateFeaturedLayoutSubject = BehaviorSubject<Void>(value: ())
    
    private var isLoggedIn: Bool {
        LoginState.current == .loggedIn
    }
    
    var userProfileInfo: UserProfileInfo? {
        guard isLoggedIn else { return nil }
        return UserDefaultsManager.shared.get(objectForkey: .userProfileInfo, type: UserProfileInfo.self)
    }
    
    var featuredSectionModel: [FeaturedSectionType] {
        featuredSectionModelRelay.value
    }
    
    init(coordinator: FeaturedCoordinator, usecase: SubscribeArtistUseCase & AllPerformanceUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let requestFeaturedSectionModel: Observable<Void>
        let didTapSearchField: Observable<UITapGestureRecognizer>
        let didTappedSubscribeGenreButton: PublishSubject<Void>
        let didTappedSubscribeArtistButton: PublishSubject<Void>
        let didTappedFeaturedCell: Observable<IndexPath>
        let didTappedWatchTheFullPerformanceButton: Observable<Void>
    }
    
    struct Output {
        let updateFeaturedLayout: Signal<Void>
        let showLoginBottomSheet: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output(
            updateFeaturedLayout: updateFeaturedLayoutSubject.asSignal(onErrorSignalWith: .empty()),
            showLoginBottomSheet: PublishSubject<Void>()
        )
        
        input.requestFeaturedSectionModel
            .subscribe(with: self) { owner, _ in
                owner.fetchSubscribeGenreListModel()
                owner.usecase.fetchArtistList()
                owner.usecase.fetchAllPerformance(state: .init(type: .recent, isOnlyUpcoming: true))
                owner.fetchRecommendedPerformanceListModel()
            }
            .disposed(by: disposeBag)
        
        input.didTapSearchField
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToFeaturedSearchScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSubscribeGenreButton
            .subscribe(with: self) { owner, _ in
                
                guard LoginState.current == .loggedIn else {
                    output.showLoginBottomSheet.onNext(())
                    return
                }
                owner.coordinator.goToSubscribeGenreScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSubscribeArtistButton
            .subscribe(with: self) { owner, _ in
                guard LoginState.current == .loggedIn else {
                    output.showLoginBottomSheet.onNext(())
                    return
                }
                owner.coordinator.goToSubscribeArtistScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedWatchTheFullPerformanceButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToFullPerformanceScreen()
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            subscribeGenreModelRelay,
            usecase.artistList,
            usecase.performanceList,
            recommendedPerformanceModelRelay
        )
        .map { result -> [FeaturedSectionType] in
            let (genreModel, artistModel, ticketingModel, recommendedModel) = result
            return [.subscribeGenre(genreModel), .subscribeArtist(artistModel), .ticketingPerformance(ticketingModel), .recommendedPerformance(recommendedModel)]
        }
        .subscribe(with: self) { owner, sectionModel in
            owner.featuredSectionModelRelay.accept(sectionModel)
            owner.updateFeaturedLayoutSubject.onNext(())
        }
        .disposed(by: disposeBag)
            
        input.didTappedFeaturedCell
            .withLatestFrom(featuredSectionModelRelay) { ($0, $1) }
            .subscribe(with: self) { owner, result in
                let (indexPath, sectionModel) = result
                let type = sectionModel[indexPath.section]
                switch type {
                case .subscribeArtist:
                    guard LoginState.current == .loggedIn else {
                        output.showLoginBottomSheet.onNext(())
                        return
                    }
                    owner.coordinator.goToSubscribeArtistScreen()
                case .subscribeGenre:
                    guard LoginState.current == .loggedIn else {
                        output.showLoginBottomSheet.onNext(())
                        return
                    }
                    owner.coordinator.goToSubscribeGenreScreen()
                case let .ticketingPerformance(model):
                    owner.coordinator.goToShowDetailScreen(showID: model[indexPath.row].showID)
                case let .recommendedPerformance(model):
                    owner.coordinator.goToShowDetailScreen(showID: model[indexPath.row].showID)
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension FeaturedViewModel {
    
    /// 구독 장르 데이터를 위한 API호출하는 함수
    private func fetchSubscribeGenreListModel() {
        let genreList = ["rock", "band", "edm", "classic", "hiphop", "house", "opera", "pop", "rnb", "musical", "metal", "jpop", "jazz"]
        subscribeGenreModelRelay.accept(genreList.compactMap { GenreType(rawValue: $0) })
    }
    
    /// 추천공연 리스트 모델을 위한 API를 호출하는 함수
    private func fetchRecommendedPerformanceListModel() {
        
        // FIXME: usecase로 옮기기
        let showAPI = SPShowAPI()
        showAPI.showList(sort: "POPULAR", size: 10)
            .map { data in
                data.data.map { show in
                    FeaturedRecommendedPerformanceCellModel(
                        showID: show.id,
                        recommendedPerformanceThumbnailURL: URL(string: show.posterImageURL),
                        recommendedPerformanceTitle: show.title
                    )
                }
            }
            .bind(to: recommendedPerformanceModelRelay)
            .disposed(by: disposeBag)
    }
}
