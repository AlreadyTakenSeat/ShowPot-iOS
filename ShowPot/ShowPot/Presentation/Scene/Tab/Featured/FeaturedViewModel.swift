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
    
    private let subscribeGenreModelRelay = BehaviorRelay<[GenreType]>(value: [])
    private let subscribeArtistModelRelay = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    private let ticketingPerformanceModelRelay = BehaviorRelay<[FeaturedPerformanceWithTicketOnSaleSoonCellModel]>(value: [])
    private let recommendedPerformanceModelRelay = BehaviorRelay<[FeaturedRecommendedPerformanceCellModel]>(value: [])
    private let featuredSectionModelRelay = BehaviorRelay<[FeaturedSectionType]>(value: [])
    private let updateFeaturedLayoutSubject = BehaviorSubject<Void>(value: ())
    
    var featuredSectionModel: [FeaturedSectionType] {
        featuredSectionModelRelay.value
    }
    
    init(coordinator: FeaturedCoordinator) {
        self.coordinator = coordinator
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
    }
    
    func transform(input: Input) -> Output {
        
        input.requestFeaturedSectionModel
            .subscribe(with: self) { owner, _ in
                owner.fetchSubscribeGenreListModel()
                owner.fetchSubscribeArtistListModel()
                owner.fetchTicketingPerformanceListModel()
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
                owner.coordinator.goToSubscribeGenreScreen()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSubscribeArtistButton
            .subscribe(with: self) { owner, _ in
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
            subscribeArtistModelRelay,
            ticketingPerformanceModelRelay,
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
                    owner.coordinator.goToSubscribeArtistScreen()
                case .subscribeGenre:
                    owner.coordinator.goToSubscribeGenreScreen()
                case let .ticketingPerformance(model):
                    owner.coordinator.goToShowDetailScreen(showID: model[indexPath.row].showID)
                case let .recommendedPerformance(model):
                    owner.coordinator.goToShowDetailScreen(showID: model[indexPath.row].showID)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(updateFeaturedLayout: updateFeaturedLayoutSubject.asSignal(onErrorSignalWith: .empty()))
    }
}

extension FeaturedViewModel {
    
    /// 구독 장르 데이터를 위한 API호출하는 함수
    private func fetchSubscribeGenreListModel() {
        let genreList = ["rock", "band", "edm", "classic", "hiphop", "house", "opera", "pop", "rnb", "musical", "metal", "jpop", "jazz"]
        subscribeGenreModelRelay.accept(genreList.compactMap { GenreType(rawValue: $0) })
    }
    
    /// 구독 아티스트 데이터를 위한 API호출하는 함수
    private func fetchSubscribeArtistListModel() {
        
        subscribeArtistModelRelay.accept([ // FIXME: - 추후 API연동 후 MockData코드 수정
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "Karina"),
            .init(state: .none, artistImageURL: URL(string: "https://archive.myvibrary.com/original/1668417270241_975a7ca2e5.jpeg"), artistName: "Promise Nine"),
            .init(state: .none, artistImageURL: URL(string: "https://i.namu.wiki/i/0JkYJV8U5hmI2TrCSbXXeqR0amYEJFCwL8dhX9ErhuHjKfMqjnLz7tjRfF9xZlxI6u44ubT-GhASuu3MIrLLKw.webp"), artistName: "Post Malone"),
            .init(state: .none, artistImageURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMDA2MjVfMTU3/MDAxNTkzMDUyMTM5MTIx.37pQgUlGVqV5UcjyqYX5_vcui9PeJQwY5S3qO5ISYtcg.rji7p3enqW1JjZjuasxxoYK6gvWYALBO2WWCVOFQhB8g.JPEG.iiwasabi/aa575f1c11d21a71b47410a3e477df52b652b2a12d0d5866ecca9b13a689bc9983299996e7c.jpeg?type=w800"), artistName: "Official HIGE DANdism"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn.hankooki.com/news/photo/202403/146167_199399_1711270059.jpg"), artistName: "Charlie Puth"),
            .init(state: .none, artistImageURL: URL(string: "https://dimg.donga.com/wps/NEWS/IMAGE/2023/10/16/121678869.2.jpg"), artistName: "Sam Smitth"),
            .init(state: .none, artistImageURL: URL(string: "https://www.rollingstone.com/wp-content/uploads/2023/09/Doja-Cat-New-album-is-out.jpg"), artistName: "Doja Cat"),
            .init(state: .none, artistImageURL: URL(string: "https://i.namu.wiki/i/7Uuzidn1EcLXJPolvEHmRR4CDwtQwfgpvXZ0HigeTiW6QCoPWXQ67n5anRe1wRMegTHPRQ5sfBwVdzdJ2MPVWQ.webp"), artistName: "Kanye West"),
            .init(state: .none, artistImageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/22/Mariah_Carey_Library_of_Congress_2023_1_Cropped_3.png"), artistName: "Mariah Carey")
        ])
    }
    
    /// 티켓팅공연 리스트 모델을 위한 API를 호출하는 함수
    private func fetchTicketingPerformanceListModel() { // FIXME: - 추후 API연동 후 MockData코드 수정
        ticketingPerformanceModelRelay.accept([
            .init(
                showID: "40", performanceState: .reserving, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), performanceDate: nil),
            .init(
                showID: "41", performanceState: .upcoming, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2015/08/22/15/39/giraffes-901009_1280.jpg"), performanceDate: Date(timeIntervalSinceNow: 24 * 60 * 60)),
        ])
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
