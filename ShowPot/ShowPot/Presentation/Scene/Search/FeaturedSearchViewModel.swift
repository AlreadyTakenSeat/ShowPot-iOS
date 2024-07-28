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
    
    private var recentSearchQueryList: [String] {
        if let recentSearchQueryList: [String] = UserDefaultsManager.shared.get(for: .recentSearchQueryList) {
            return recentSearchQueryList
        }
        return []
    }
    
    /// 현재 가장 상단에 보이는 화면
    private var currentSearchScreen: CurrentSearchScreen = .recentSearchList
    
    /// 최근 검색어 최대 갯수
    private let maxSearchCount = 7
    
    private let recentSearchListRelay = BehaviorRelay<[String]>(value: UserDefaultsManager.shared.get(for: .recentSearchQueryList) ?? [])
    private let performanceResultListRelay = BehaviorRelay<[PerformanceInfoCollectionViewCellModel]>(value: [])
    private let artistResultListRelay = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var recentSearchQueryDataSource: RecentSearchQueryDataSource?
    var searchQueryResultDataSource: SearchQueryResultDataSource?
    
    init(coordinator: FeaturedSearchCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let requestInitialSearchQueryData: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedRemoveAllButton: Observable<Void>
        let didTappedRecentSearchQuery: Observable<IndexPath>
        let didTappedRecentSearchQueryXButton: Observable<String>
        let didTappedReturnKey: Observable<String>
        let searchQueryTextField: ControlProperty<String>
        let didTappedSearchTextFieldXButton: Observable<Void>
        let didTappedSearchResultCell: Observable<IndexPath>
    }
    
    struct Output {
        let isRecentSearchQueryListEmpty: Driver<Bool>
        let isSearchResultEmpty: Driver<Bool>
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedSearchResultCell
            .subscribe(with: self) { owner, indexPath in
                guard let dataSource = owner.searchQueryResultDataSource else { return }
                var snapshot = dataSource.snapshot()
                let sectionIdentifier = snapshot.sectionIdentifiers[indexPath.section]
                
                switch sectionIdentifier {
                case .artistList:
                    var artistModel = owner.artistResultListRelay.value
                    guard artistModel[indexPath.row].state == .availableSubscription else { return }
                    artistModel[indexPath.row].state = .selected
                    owner.artistResultListRelay.accept(artistModel)
                    owner.updateSearchResultDataSource()
                case .performanceInfo:
                    LogHelper.debug("검색결과 공연정보 선택")
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedRecentSearchQueryXButton
            .subscribe(with: self) { owner, query in
                owner.remove(query: query)
                owner.updateRecentSearchDataSource()
            }
            .disposed(by: disposeBag)
        
        input.requestInitialSearchQueryData
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
        
        input.didTappedReturnKey
            .subscribe(with: self) { owner, searchQuery in
                owner.handleSearch(query: searchQuery)
            }
            .disposed(by: disposeBag)
        
        input.didTappedRecentSearchQuery
            .subscribe(with: self) { owner, indexPath in
                let query = owner.findSearchQuery(indexPath: indexPath)
                owner.handleSearch(query: query)
            }
            .disposed(by: disposeBag)
        
        input.didTappedSearchTextFieldXButton
            .subscribe(with: self) { owner, _ in
                owner.clearSearchResults()
            }
            .disposed(by: disposeBag)
        
        input.searchQueryTextField
            .filter { $0.isEmpty }
            .subscribe(with: self) { owner, isEmpty in
                owner.clearSearchResults()
            }
            .disposed(by: disposeBag)
        
        let isRecentSearchQueryListEmpty = recentSearchListRelay
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
            isRecentSearchQueryListEmpty: isRecentSearchQueryListEmpty,
            isSearchResultEmpty: isSearchResultEmpty,
            isLoading: isLoading
        )
    }
}

extension FeaturedSearchViewModel {
    
    /// 검색쿼리를 이용해 검색 API를 호출하는 함수
    private func fetchSearchResult(searchQuery: String) {
        isLoadingRelay.accept(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // FIXME: - 추후 MockData수정 및 asyncAfter 코드 삭제
            
            self.artistResultListRelay.accept([
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
                .init(state: .availableSubscription, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird")
            ])
            
            self.performanceResultListRelay.accept([
                
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀"),
                .init(performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: "2024.12.4 (수) 오후 8시", performanceLocation: "KBS 아레나홀")
            ])
            self.isLoadingRelay.accept(false)
            self.updateSearchResultDataSource()
        }
    }
}

// MARK: - FeaturedSearch Helper

extension FeaturedSearchViewModel {
    
    private func findSearchQuery(indexPath: IndexPath) -> String {
        recentSearchListRelay.value[indexPath.row]
    }
    
    private func add(query: String) {
        var queryList = recentSearchListRelay.value
        
        if queryList.contains(query) {
            queryList.removeAll(where: { $0 == query })
        } else if queryList.count >= maxSearchCount {
            queryList.removeLast()
        }
        
        queryList.insert(query, at: 0)
        recentSearchListRelay.accept(queryList)
        UserDefaultsManager.shared.set(queryList, for: .recentSearchQueryList)
    }
    
    private func remove(query: String) {
        var queryList = recentSearchListRelay.value
        guard queryList.contains(query) else { return }
        queryList.removeAll(where: { $0 == query })
        recentSearchListRelay.accept(queryList)
        UserDefaultsManager.shared.set(queryList, for: .recentSearchQueryList)
    }
    
    private func removeAll() {
        LogHelper.debug("모두삭제 버튼 클릭")
        guard !recentSearchListRelay.value.isEmpty else { return }
        recentSearchListRelay.accept([])
        UserDefaultsManager.shared.set([], for: .recentSearchQueryList)
    }
    
    private func handleBackButtonTap() {
        if currentSearchScreen == .recentSearchList {
            coordinator.popViewController()
        } else {
            performanceResultListRelay.accept([])
            artistResultListRelay.accept([])
            currentSearchScreen = .recentSearchList
        }
    }
    
    private func handleSearch(query: String) {
        add(query: query)
        fetchSearchResult(searchQuery: query)
        updateRecentSearchDataSource()
        updateSearchResultDataSource()
        currentSearchScreen = .searchResult
    }
    
    private func clearSearchResults() {
        if !performanceResultListRelay.value.isEmpty || !artistResultListRelay.value.isEmpty {
            performanceResultListRelay.accept([])
            artistResultListRelay.accept([])
        }
        currentSearchScreen = .recentSearchList
    }
}

// MARK: - For NSDiffableDataSource

extension FeaturedSearchViewModel {
    
    typealias RecentSearchItem = String
    typealias SearchResultItem = AnyHashable
    typealias RecentSearchQueryDataSource = UICollectionViewDiffableDataSource<RecentSearchSection, RecentSearchItem>
    typealias SearchQueryResultDataSource = UICollectionViewDiffableDataSource<SearchResultSection, SearchResultItem>
    
    /// 최근 검색어 리스트 섹션 타입
    enum RecentSearchSection: CaseIterable {
        case main
    }
    
    /// 검색 결과 섹션 타입
    enum SearchResultSection: CaseIterable {
        case artistList
        case performanceInfo
        
        var headerTitle: String {
            switch self {
            case .artistList:
                return "아티스트"
            case .performanceInfo:
                return "공연 정보"
            }
        }
    }
    
    /// 현재 최상단 검색화면
    enum CurrentSearchScreen {
        case recentSearchList
        case searchResult
    }
    
    private func updateRecentSearchDataSource() {
        let queryList = recentSearchListRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<RecentSearchSection, RecentSearchItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(queryList)
        recentSearchQueryDataSource?.apply(snapshot)
    }
    
    private func updateSearchResultDataSource() {
        let artistResultList = artistResultListRelay.value
        let performanceResultList = performanceResultListRelay.value
        
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultSection, SearchResultItem>()
        snapshot.appendSections([.artistList, .performanceInfo])
        snapshot.appendItems(artistResultList, toSection: .artistList)
        snapshot.appendItems(performanceResultList, toSection: .performanceInfo)
        
        searchQueryResultDataSource?.apply(snapshot)
    }
}
