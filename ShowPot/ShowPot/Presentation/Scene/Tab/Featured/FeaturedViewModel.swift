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
        self.configureInput(input)
        return self.createOutput(from: input)
    }
    
    private func configureInput(_ input: Input) {
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
    }
    
    private func createOutput(from input: Input) -> Output {
        let output = Output(
            updateFeaturedLayout: updateFeaturedLayoutSubject.asSignal(onErrorSignalWith: .empty()),
            showLoginBottomSheet: PublishSubject<Void>()
        )
        
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
    private func fetchRecommendedPerformanceListModel() { // FIXME: - 추후 API연동 후 MockData코드 수정
        let mockData: [FeaturedRecommendedPerformanceCellModel] = [
            .init(
                showID: "0191948f-0ba0-2a3b-9b19-bd42694ecf58",
                recommendedPerformanceThumbnailURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24006288_p.gif"),
                recommendedPerformanceTitle: "Conan Gray - Found Heaven On Tour in Seoul"
            ),
            .init(
                showID: "01919906-7fb9-6552-3819-91a5295bb3e6 ",
                recommendedPerformanceThumbnailURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24006714_p.gif"),
                recommendedPerformanceTitle: "Olivia Rodrigo - GUTS world tour")
            ,
            .init(
                showID: "01919901-105d-b5b2-cbaf-912f20281ce8",
                recommendedPerformanceThumbnailURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24011642_p.gif"),
                recommendedPerformanceTitle: "OFFICIAL HIGE DANDISM REJOICE ASIA TOUR 2024"
            ),
            .init(
                showID: "019194a4-e4ba-f2d1-79d6-23088c9c3112",
                recommendedPerformanceThumbnailURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24007623_p.gif"),
                recommendedPerformanceTitle: "Dua Lipa - Radical Optimism Tour"
            )
        ]
        
        recommendedPerformanceModelRelay.accept(mockData)
    }
}
