//
//  FeaturedSearchViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeaturedSearchViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    var coordinator: FeaturedSearchCoordinator
    
    private var recentSearchKeywordList: [String] {
        UserDefaultsManager.shared.get(for: .recentSearchKeywordList) ?? []
    }
    
    /// 현재 가장 상단에 보이는 화면
    private var currentSearchScreen: CurrentSearchScreen = .recentSearch
    
    /// 최근 검색어 최대 갯수
    private let maxSearchCount = 7
    
    private lazy var recentSearchListRelay = BehaviorRelay<[String]>(value: recentSearchKeywordList)
    private let performanceResultListRelay = BehaviorRelay<[PerformanceInfoCollectionViewCellModel]>(value: [])
    private let artistResultListRelay = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var recentSearchKeywordDataSource: RecentSearchKeywordDataSource?
    var searchKeywordResultDataSource: SearchKeywordResultDataSource?
    
    init(coordinator: FeaturedSearchCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let initialSearchKeyword: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedRemoveAllButton: Observable<Void>
        let didTappedRecentSearchKeyword: Observable<IndexPath>
        let didTappedRemoveKeywordButton: Observable<String>
        let didTappedReturnKey: Observable<String>
        let searchKeyword: Observable<String>
        let didTappedSearchFieldRemoveAllButton: Observable<Void>
        let didTappedSearchResultCell: Observable<IndexPath>
    }
    
    struct Output {
        let isRecentSearchKeywordEmpty: Driver<Bool>
        let isSearchResultEmpty: Driver<Bool>
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedSearchResultCell
            .subscribe(with: self) { owner, indexPath in
                guard let dataSource = owner.searchKeywordResultDataSource else { return }
                let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[indexPath.section]
                
                switch sectionIdentifier { // FIXME: - 추후 구독 API 성공 및 실패 시 다음 동작 구현 필요
                case .artist:
                    var artistModel = owner.artistResultListRelay.value
                    if artistModel[indexPath.row].state == .availableSubscription {
                        LogHelper.debug("아티스트 구독선택\n모델: \(artistModel[indexPath.row])")
                        artistModel[indexPath.row].state = .subscription
                    } else if artistModel[indexPath.row].state == .subscription {
                        LogHelper.debug("아티스트 구독취소선택\n모델: \(artistModel[indexPath.row])")
                        artistModel[indexPath.row].state = .availableSubscription
                    }
                    owner.artistResultListRelay.accept(artistModel)
                    owner.updateSearchResultDataSource()
                case .performance:
                    var performanceModel = owner.performanceResultListRelay.value
                    LogHelper.debug("공연정보 선택\n모델: \(performanceModel[indexPath.row])")
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedRemoveKeywordButton
            .subscribe(with: self) { owner, keyword in
                owner.remove(keyword: keyword)
                owner.updateRecentSearchDataSource()
            }
            .disposed(by: disposeBag)
        
        input.initialSearchKeyword
            .subscribe(with: self) { owner, _ in
                owner.updateRecentSearchDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.handleBackButtonTap()
            }
            .disposed(by: disposeBag)
        
        input.didTappedRemoveAllButton
            .subscribe(with: self) { owner, _ in
                owner.removeAll()
                owner.updateRecentSearchDataSource()
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.didTappedReturnKey,
            input.didTappedRecentSearchKeyword
                .withUnretained(self)
                .map { $0.0.findSearchKeyword(indexPath: $0.1) }
        )
        .subscribe(with: self) { owner, searchKeyword in
            owner.handleSearch(keyword: searchKeyword)
        }
        .disposed(by: disposeBag)
        
        Observable.merge(
            input.didTappedSearchFieldRemoveAllButton,
            input.searchKeyword.filter { $0.isEmpty }.map { _ in Void() }
        )
        .subscribe(with: self) { owner, _ in
            owner.clearSearchResults()
        }
        .disposed(by: disposeBag)
        
        let isRecentSearchKeywordEmpty = recentSearchListRelay
            .map { $0.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
        
        let isSearchResultEmpty = Observable.combineLatest(
            artistResultListRelay,
            performanceResultListRelay
        )
            .map { $0.0.isEmpty && $0.1.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
        
        let isLoading = isLoadingRelay.asDriver()
        
        return Output(
            isRecentSearchKeywordEmpty: isRecentSearchKeywordEmpty,
            isSearchResultEmpty: isSearchResultEmpty,
            isLoading: isLoading
        )
    }
}

extension FeaturedSearchViewModel {
    
    /// 검색쿼리를 이용해 검색 API를 호출하는 함수
    private func fetchSearchResult(keyword: String) {
        isLoadingRelay.accept(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // FIXME: - 추후 MockData수정 및 asyncAfter 코드 삭제
            
            self.artistResultListRelay.accept([
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://i.imgur.com/KsEXGAZ.jpg"), artistName: "Marilia Mendonca"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://cdn.mhns.co.kr/news/photo/201901/157199_206779_07.jpg"), artistName: "The Chainsmokers"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://t3.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/2fG8/image/sxiZQJy0MaesFjfzRRoyNWNRmhM.jpg"), artistName: "Beyonce"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://cdn.redian.org/news/photo/202108/155857_52695_0153.jpg"), artistName: "Adele"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F1709EC404F290F7720"), artistName: "Imagine Dragons"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAxOTEwMzBfMjM1/MDAxNTcyNDI4Mzg2NjI2.vFBBiLlc8YhPuny8BFHTYczJzoR1ObVC8ZHX2iAGye4g.BVn1BX_bMjbib22Ks-l2VCQUd70yU7o8vNBLcBhSH1gg.PNG.alvin5092/1572428385660.png?type=w800"), artistName: "Maluma"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://i.namu.wiki/i/jrUaXffKzxPCo876eNO8GRdQb81OBQuNV99GnN1pDlXkGcvEsyTJaEtCsWzEtjy4yVoOnPqP058LrPswAh7KQQ.webp"), artistName: "Bruno Mars")
            ])
            
            self.performanceResultListRelay.accept([
                
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60), performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://image.bugsm.co.kr/essential/images/500/39/3978.jpg"), performanceTitle: "샘스미스단독공연", performanceTime: Date(timeIntervalSinceNow: 24 * 60), performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/03/06/2303060940437270.jpg"), performanceTitle: "안젤리나졸리단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60), performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://www.gugakpeople.com/data/gugakpeople_com/mainimages/202407/2024071636209869.jpg"), performanceTitle: "브루노마스단독고연", performanceTime: Date(timeIntervalSinceNow: 24), performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/06/05/2306051642145540.jpg"), performanceTitle: "워시단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60), performanceLocation: "KBS 아레나홀")
            ])
            self.isLoadingRelay.accept(false)
            self.updateSearchResultDataSource()
        }
    }
    
    /// 특정 아티스트를 구독하는 함수
    private func subscribeArtist() {
        
    }
    
    /// 특정 아티스트를 구독취소하는 함수
    private func cancelSubscribeArtist() {
        
    }
}

// MARK: - FeaturedSearch Helper

extension FeaturedSearchViewModel {
    
    private func findSearchKeyword(indexPath: IndexPath) -> String {
        recentSearchListRelay.value[indexPath.row]
    }
    
    private func add(keyword: String) {
        var keywordList = recentSearchListRelay.value
        
        if keywordList.contains(keyword) {
            keywordList.removeAll(where: { $0 == keyword })
        } else if keywordList.count >= maxSearchCount {
            keywordList.removeLast()
        }
        
        keywordList.insert(keyword, at: 0)
        recentSearchListRelay.accept(keywordList)
        UserDefaultsManager.shared.set(keywordList, for: .recentSearchKeywordList)
    }
    
    private func remove(keyword: String) {
        var keywordList = recentSearchListRelay.value
        guard keywordList.contains(keyword) else { return }
        keywordList.removeAll(where: { $0 == keyword })
        recentSearchListRelay.accept(keywordList)
        UserDefaultsManager.shared.set(keywordList, for: .recentSearchKeywordList)
    }
    
    private func removeAll() {
        LogHelper.debug("모두삭제 버튼 클릭")
        guard !recentSearchListRelay.value.isEmpty else { return }
        recentSearchListRelay.accept([])
        UserDefaultsManager.shared.set([], for: .recentSearchKeywordList)
    }
    
    private func handleBackButtonTap() {
        if currentSearchScreen == .recentSearch {
            coordinator.popViewController()
        } else {
            performanceResultListRelay.accept([])
            artistResultListRelay.accept([])
            currentSearchScreen = .recentSearch
        }
    }
    
    private func handleSearch(keyword: String) {
        add(keyword: keyword)
        fetchSearchResult(keyword: keyword)
        updateRecentSearchDataSource()
        updateSearchResultDataSource()
        currentSearchScreen = .searchResult
    }
    
    private func clearSearchResults() {
        if !performanceResultListRelay.value.isEmpty || !artistResultListRelay.value.isEmpty {
            performanceResultListRelay.accept([])
            artistResultListRelay.accept([])
        }
        currentSearchScreen = .recentSearch
    }
}

// MARK: - For NSDiffableDataSource

extension FeaturedSearchViewModel {
    
    typealias RecentSearchItem = String
    typealias SearchResultItem = AnyHashable
    typealias RecentSearchKeywordDataSource = UICollectionViewDiffableDataSource<RecentSearchSection, RecentSearchItem>
    typealias SearchKeywordResultDataSource = UICollectionViewDiffableDataSource<SearchResultSection, SearchResultItem>
    
    /// 최근 검색어 리스트 섹션 타입
    enum RecentSearchSection {
        case main
    }
    
    /// 검색 결과 섹션 타입
    enum SearchResultSection: CaseIterable {
        case artist
        case performance
        
        var headerTitle: String {
            switch self {
            case .artist:
                return Strings.searchArtistTitle
            case .performance:
                return Strings.searchPerformanceTitle
            }
        }
    }
    
    /// 현재 최상단 검색화면
    enum CurrentSearchScreen {
        case recentSearch
        case searchResult
    }
    
    private func updateRecentSearchDataSource() {
        let keywordList = recentSearchListRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<RecentSearchSection, RecentSearchItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(keywordList)
        recentSearchKeywordDataSource?.apply(snapshot)
    }
    
    private func updateSearchResultDataSource() {
        let artistResultList = artistResultListRelay.value
        let performanceResultList = performanceResultListRelay.value
        
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultSection, SearchResultItem>()
        snapshot.appendSections([.artist, .performance])
        snapshot.appendItems(artistResultList, toSection: .artist)
        snapshot.appendItems(performanceResultList, toSection: .performance)
        
        searchKeywordResultDataSource?.apply(snapshot)
    }
}
