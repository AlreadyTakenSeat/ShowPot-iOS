//
//  FeaturedViewModel.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation

import RxSwift
import RxCocoa

final class FeaturedViewModel: ViewModelType {
    
    var coordinator: FeaturedCoordinator
    private let disposeBag = DisposeBag()
    
    private let subscribeGenreModelRelay = BehaviorRelay<[FeaturedSubscribeGenreCellModel]>(value: [])
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
    
    struct Input { // TODO: - 상단 서치바완성되면 연동 필요
        let requestFeaturedSectionModel: Observable<Void>
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
                default:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        return Output(updateFeaturedLayout: updateFeaturedLayoutSubject.asSignal(onErrorSignalWith: .empty()))
    }
}

extension FeaturedViewModel {
    
    /// 구독 장르 데이터를 위한 API호출하는 함수
    private func fetchSubscribeGenreListModel() {
        subscribeGenreModelRelay.accept([ // FIXME: - 추후 API연동 후 MockData코드 수정
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg")),
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg")),
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg")),
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg")),
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg")),
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg")),
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg")),
            .init(subscribeGenreImageURL: URL(string: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/09/18/1e586277-48ba-4e8a-9b98-d8cdbe075d86.jpg"))
        ])
    }
    
    /// 구독 아티스트 데이터를 위한 API호출하는 함수
    private func fetchSubscribeArtistListModel() {
        
        subscribeArtistModelRelay.accept([ // FIXME: - 추후 API연동 후 MockData코드 수정
            .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .selected, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird")
        ])
    }
    
    /// 티켓팅공연 리스트 모델을 위한 API를 호출하는 함수
    private func fetchTicketingPerformanceListModel() { // FIXME: - 추후 API연동 후 MockData코드 수정
        ticketingPerformanceModelRelay.accept([
            .init(
                perfonmanceState: .reserving, performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg")),
            .init(
                perfonmanceState: .upcoming(Date(timeIntervalSinceNow: 24 * 60 * 60)), performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2015/08/22/15/39/giraffes-901009_1280.jpg")),
            .init(
                perfonmanceState: .upcoming(Date(timeIntervalSinceNow: 24 * 60)), performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2016/03/05/22/17/food-1239231_1280.jpg")),
            .init(
                perfonmanceState: .upcoming(Date(timeIntervalSinceNow: 24 * 60 * 60 * 60)), performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2015/10/10/13/41/polar-bear-980781_1280.jpg")),
            .init(
                perfonmanceState: .upcoming(Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60)), performanceTitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceLocation: "KBS 아레나홀", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2014/04/05/11/41/butterfly-316740_1280.jpg")),
            .init(
                perfonmanceState: .upcoming(Date(timeIntervalSinceNow: 24 * 60 * 60 * 60 * 60 * 60)), performanceTitle: "Nothing But Thieves But Thieves ", performanceLocation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna a", performanceImageURL: URL(string: "https://cdn.pixabay.com/photo/2024/03/24/14/47/hippopotamus-8653246_1280.png"))
        ])
    }
    
    /// 추천공연 리스트 모델을 위한 API를 호출하는 함수
    private func fetchRecommendedPerformanceListModel() { // FIXME: - 추후 API연동 후 MockData코드 수정
        recommendedPerformanceModelRelay.accept([
            .init(recommendedPerformanceThumbnailURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5NfNwM67Lyk98rVjmz7FHKxaBF4XgoPATw&s"), recommendedPerformanceTitle: "Nothing But Thieves hey.d."),
            .init(recommendedPerformanceThumbnailURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5NfNwM67Lyk98rVjmz7FHKxaBF4XgoPATw&s"), recommendedPerformanceTitle: "Nothing But Thieves hey.d."),
            .init(recommendedPerformanceThumbnailURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5NfNwM67Lyk98rVjmz7FHKxaBF4XgoPATw&s"), recommendedPerformanceTitle: "Nothing But Thieves hey.d."),
            .init(recommendedPerformanceThumbnailURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5NfNwM67Lyk98rVjmz7FHKxaBF4XgoPATw&s"), recommendedPerformanceTitle: "Nothing But Thieves hey.d."),
            .init(recommendedPerformanceThumbnailURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5NfNwM67Lyk98rVjmz7FHKxaBF4XgoPATw&s"), recommendedPerformanceTitle: "Nothing But Thieves hey.d."),
            .init(recommendedPerformanceThumbnailURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5NfNwM67Lyk98rVjmz7FHKxaBF4XgoPATw&s"), recommendedPerformanceTitle: "Nothing But Thieves hey.d.")
        ])
    }
}
