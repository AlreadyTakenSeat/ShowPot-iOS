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
                guard LoginState.current == .loggedIn else {
                    output.showLoginBottomSheet.onNext(())
                    return
                }
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
    private func fetchRecommendedPerformanceListModel() { // FIXME: - 추후 API연동 후 MockData코드 수정
        recommendedPerformanceModelRelay.accept([
            .init(showID: "1", recommendedPerformanceThumbnailURL: URL(string: "https://img1.newsis.com/2017/06/08/NISI20170608_0000003586_web.jpg"), recommendedPerformanceTitle: "Ed Sheeran In Seoul"),
            .init(showID: "2", recommendedPerformanceThumbnailURL: URL(string: "https://m.segye.com/content/image/2023/04/20/20230420524301.jpg"), recommendedPerformanceTitle: "Bruno Mars Super Concert"),
            .init(showID: "3", recommendedPerformanceThumbnailURL: URL(string: "https://newsimg-hams.hankookilbo.com/2022/06/23/00f9568a-226c-4b99-b0b1-d44284b7c477.jpg"), recommendedPerformanceTitle: "Bille Eilish Seoul Kaidom"),
            .init(showID: "4", recommendedPerformanceThumbnailURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSL0vSEZjCwFA2APIB_YgRwqovQAs5CJaN_uA&s"), recommendedPerformanceTitle: "FLY BY MIDNIGHT ANEMOLA"),
            .init(showID: "5", recommendedPerformanceThumbnailURL: URL(string: "https://m.segye.com/content/image/2023/12/07/20231207516433.jpg"), recommendedPerformanceTitle: "NO WAR LIVE IN SEOUL"),
            .init(showID: "6", recommendedPerformanceThumbnailURL: URL(string: "https://tkfile.yes24.com/upload2/PerfBlog/202407/20240710/20240710-50315.jpg"), recommendedPerformanceTitle: "Novelbright LIVE TOUR 2024")
        ])
    }
}
