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
    private let usecase: SearchUseCase
    var coordinator: FeaturedSearchCoordinator
    
    private var recentSearchKeywordList: [String] {
        UserDefaultsManager.shared.get(for: .recentSearchKeywordList) ?? []
    }
    
    /// 현재 가장 상단에 보이는 화면
    private var currentSearchScreen: CurrentSearchScreen = .recentSearch
    
    /// 최근 검색어 최대 갯수
    private let maxSearchCount = 7
    
    private lazy var recentSearchListRelay = BehaviorRelay<[String]>(value: recentSearchKeywordList)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let showSearchResultRelay = PublishRelay<Bool>()
    
    var recentSearchKeywordDataSource: RecentSearchKeywordDataSource?
    var searchKeywordResultDataSource: SearchKeywordResultDataSource?
    
    init(coordinator: FeaturedSearchCoordinator, usecase: SearchUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
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
        let showSearchResult: Driver<Bool>
        let isLoading: Driver<Bool>
        
        /// 아티스트 구독 요청 결과
        var addSubscriptionResult = PublishSubject<Bool>()
        /// 아티스트 구독 취소 요청 결과
        var deleteSubscriptionResult = PublishSubject<Bool>()
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedSearchResultCell
            .subscribe(with: self) { owner, indexPath in
                guard let dataSource = owner.searchKeywordResultDataSource else { return }
                let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[indexPath.section]
                
                switch sectionIdentifier { // FIXME: - 추후 구독 API 성공 및 실패 시 다음 동작 구현 필요
                case .artist:
                    var artistModel = owner.usecase.artistSearchResult.value[indexPath.row]
                    if artistModel.state == .availableSubscription {
                        owner.usecase.addSubscribtion(artistID: artistModel.id)
                    } else if artistModel.state == .subscription {
                        owner.usecase.deleteSubscribtion(artistID: artistModel.id)
                    }
                case .performance:
                    let performanceModel = owner.usecase.showSearchResult.value
                    owner.coordinator.goToShowDetailScreen(showID: performanceModel[indexPath.row].showID)
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedRemoveKeywordButton
            .subscribe(with: self) { owner, keyword in
                owner.remove(keyword: keyword)
                owner.updateRecentSearchDataSource()
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
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
                owner.showSearchResultRelay.accept(false)
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
            owner.showSearchResultRelay.accept(false)
        }
        .disposed(by: disposeBag)
        
        let isRecentSearchKeywordEmpty = recentSearchListRelay
            .map { $0.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
        
        Observable.combineLatest(
            usecase.artistSearchResult,
            usecase.showSearchResult
        )
        .subscribe(with: self) { owner, _ in
            owner.isLoadingRelay.accept(false)
            owner.updateSearchResultDataSource()
            owner.showSearchResultRelay.accept(true)
        }
        .disposed(by: disposeBag)
        
        let isLoading = isLoadingRelay.asDriver()
        
        let output = Output(
            isRecentSearchKeywordEmpty: isRecentSearchKeywordEmpty,
            showSearchResult: showSearchResultRelay.asDriver(onErrorDriveWith: .empty()),
            isLoading: isLoading
        )
        
        usecase.addSubscribtionresult
            .subscribe(with: self) { owner, result in
                let (artistID, isSuccess) = result
                output.addSubscriptionResult.onNext(isSuccess)
                guard !isSuccess else { return }
                owner.updateArtistSubscription(to: .subscription, for: artistID)
            }
            .disposed(by: disposeBag)
        
        usecase.deleteSubscribtionresult
            .subscribe(with: self) { owner, result in
                let (artistID, isSuccess) = result
                output.deleteSubscriptionResult.onNext(isSuccess)
                guard !isSuccess else { return }
                owner.updateArtistSubscription(to: .availableSubscription, for: artistID)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension FeaturedSearchViewModel {
    
    /// 검색쿼리를 이용해 검색 API를 호출하는 함수
    private func fetchSearchResult(keyword: String) {
        isLoadingRelay.accept(true)
        usecase.searchArtist(search: keyword, cursor: nil)
        usecase.searchShowList(search: keyword, cursor: nil)
    }
    
    private func updateArtistSubscription(to status: FeaturedSubscribeArtistCellState, for artistID: String) {
        var currentArtistResult = usecase.artistSearchResult.value
        guard let index = currentArtistResult.firstIndex(where: { $0.id == artistID }) else { return }
        currentArtistResult[index].state = status
        usecase.artistSearchResult.accept(currentArtistResult)
        updateSearchResultDataSource()
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
        guard !recentSearchListRelay.value.isEmpty else { return }
        recentSearchListRelay.accept([])
        UserDefaultsManager.shared.set([], for: .recentSearchKeywordList)
    }
    
    private func handleBackButtonTap() {
        if currentSearchScreen == .recentSearch {
            coordinator.popViewController()
        } else {
            usecase.showSearchResult.accept([])
            usecase.artistSearchResult.accept([])
            currentSearchScreen = .recentSearch
            showSearchResultRelay.accept(false)
        }
    }
    
    private func handleSearch(keyword: String) {
        add(keyword: keyword)
        fetchSearchResult(keyword: keyword)
        updateRecentSearchDataSource()
        currentSearchScreen = .searchResult
    }
    
    private func clearSearchResults() {
        if !usecase.showSearchResult.value.isEmpty || !usecase.artistSearchResult.value.isEmpty {
            usecase.showSearchResult.accept([])
            usecase.artistSearchResult.accept([])
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
        let artistResultList = usecase.artistSearchResult.value
        let performanceResultList = usecase.showSearchResult.value
        
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultSection, SearchResultItem>()
        snapshot.appendSections([.artist, .performance])
        snapshot.appendItems(artistResultList, toSection: .artist)
        snapshot.appendItems(performanceResultList, toSection: .performance)
        
        searchKeywordResultDataSource?.apply(snapshot)
    }
}
