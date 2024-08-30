//
//  SubscribeArtistViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SubscribeArtistViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let subscribeArtistIDList = BehaviorRelay<[String]>(value: [])
    private let showLoginAlertSubject = PublishSubject<Void>()
    
    private let usecase: SubscribeArtistUseCase
    var coordinator: SubscribeArtistCoordinator
    var dataSource: DataSource?
    var isLoggedIn: Bool {
        LoginState.current == .loggedIn
    }
    
    init(coordinator: SubscribeArtistCoordinator, usecase: SubscribeArtistUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let didTappedBackButton: Observable<Void>
        let didTappedArtistCell: Observable<IndexPath>
        let didTappedSubscribeButton: Observable<Void>
        let didTappedSnackbarButton: Observable<Void>
    }
    
    struct Output {
        let isShowSubscribeButton: Driver<Bool>
        let showLoginAlert: Driver<Void>
        var subscribeArtistResult = PublishSubject<Bool>()
    }
    
    func transform(input: Input) -> Output {
        
        usecase.artistList
            .subscribe(with: self) { owner, artistList in
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedArtistCell
            .subscribe(with: self) { owner, indexPath in
                let idList = owner.subscribeArtistIDList.value
                var artistList = owner.usecase.artistList.value
                LogHelper.debug("선택한 셀 모델: \(artistList[indexPath.row])")
                switch artistList[indexPath.row].state {
                case .none:
                    artistList[indexPath.row].state = .selected
                    owner.add(artistID: artistList[indexPath.row].id)
                case .selected:
                    artistList[indexPath.row].state = .none
                    owner.remove(artistID: artistList[indexPath.row].id)
                default:
                    return
                }
                owner.usecase.artistList.accept(artistList)
            }
            .disposed(by: disposeBag)
        
        input.didTappedSubscribeButton
            .subscribe(with: self) { owner, _ in
                if owner.isLoggedIn {
                    let artistID = owner.subscribeArtistIDList.value
                    LogHelper.debug("구독한 아티스트 아이디: \(artistID)")
                    owner.usecase.subscribeArtists(artistID: artistID)
                }
                else {
                    owner.showLoginAlertSubject.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSnackbarButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToSubscribeArtistScreen()
            }
            .disposed(by: disposeBag)
        
        let isShowSubscribeButton = subscribeArtistIDList
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
        
        let showLoginAlert = showLoginAlertSubject.asDriver(onErrorDriveWith: .empty())
        
        let output = Output(
            isShowSubscribeButton: isShowSubscribeButton,
            showLoginAlert: showLoginAlert
        )
        
        usecase.subscribeArtistResult
            .subscribe(with: self) { owner, isSuccess in
                if isSuccess {
                    owner.filterArtistList(artistID: owner.subscribeArtistIDList.value)
                    owner.subscribeArtistIDList.accept([])
                }
                output.subscribeArtistResult.onNext(isSuccess)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    func fetchArtistList() {
        usecase.fetchArtistList()
    }
}


extension SubscribeArtistViewModel {
    
    /// 구독된 아티스트정보를 가지고 필터하는 함수
    private func filterArtistList(artistID: [String]) {
        let artistList = usecase.artistList.value
        let filteredArtistList = artistList.filter { !artistID.contains($0.id) }
        
        usecase.artistList.accept(filteredArtistList)
        subscribeArtistIDList.accept([])
        updateDataSource()
    }
    
    /// 구독하기위한 아티스트를 추가하는 함수
    private func add(artistID: String) {
        var subscriptionList = subscribeArtistIDList.value
        subscriptionList.append(artistID)
        subscribeArtistIDList.accept(subscriptionList)
    }
    
    /// 구독하기위한 아티스트를 제거하는 함수
    private func remove(artistID: String) {
        var subscriptionList = subscribeArtistIDList.value
        subscriptionList.removeAll(where: { $0 == artistID })
        subscribeArtistIDList.accept(subscriptionList)
    }
}

// MARK: - For NSDiffableDataSource

extension SubscribeArtistViewModel {
    
    typealias Item = FeaturedSubscribeArtistCellModel
    typealias DataSource = UICollectionViewDiffableDataSource<ArtistSection, Item>
    
    /// 아티스트 구독 섹션 타입
    enum ArtistSection {
        case main
    }
    
    private func updateDataSource() {
        let artistList = usecase.artistList.value
        var snapshot = NSDiffableDataSourceSnapshot<ArtistSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(artistList)
        dataSource?.apply(snapshot)
    }
}
