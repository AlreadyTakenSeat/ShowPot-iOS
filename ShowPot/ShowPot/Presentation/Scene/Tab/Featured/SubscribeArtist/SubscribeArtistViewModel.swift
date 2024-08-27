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
    private let artistListRelay = BehaviorRelay<[FeaturedSubscribeArtistCellModel]>(value: [])
    private let subscribeArtistIDList = BehaviorRelay<[String]>(value: [])
    private let showLoginAlertSubject = PublishSubject<Void>()
    private let showCompleteAlertSubject = PublishSubject<Void>()
    
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
        let viewDidLoad: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedArtistCell: Observable<IndexPath>
        let didTappedSubscribeButton: Observable<Void>
    }
    
    struct Output {
        let isShowSubscribeButton: Driver<Bool>
        let showLoginAlert: Driver<Void>
        let showCompleteAlert: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                Task {
                    do {
                        let artistList = try await owner.usecase.fetchArtistList()
                        owner.artistListRelay.accept(artistList)
                        owner.updateDataSource()
                    } catch {
                        // TODO: - 추후 에러 처리필요
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedArtistCell
            .subscribe(with: self) { owner, indexPath in
                var idList = owner.subscribeArtistIDList.value
                var artistList = owner.artistListRelay.value
                LogHelper.debug("선택한 셀 모델: \(artistList[indexPath.row])")
                switch artistList[indexPath.row].state {
                case .none:
                    artistList[indexPath.row].state = .selected
                    owner.add(artistID: artistList[indexPath.row].artistName) // FIXME: - 추후 아티스트 ID로 수정 필수
                case .selected:
                    artistList[indexPath.row].state = .none
                    owner.remove(artistID: artistList[indexPath.row].artistName) // FIXME: - 추후 아티스트 ID로 수정 필수
                default:
                    return
                }
                owner.artistListRelay.accept(artistList)
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSubscribeButton
            .subscribe(with: self) { owner, _ in
                if owner.isLoggedIn {
                    Task {
                        do {
                            let artistID = owner.subscribeArtistIDList.value
                            LogHelper.debug("구독한 아티스트 아이디: \(artistID)")
                            let subscribedArtistID = try await owner.usecase.subscribeArtists(artistID: artistID)
                            var artistList = owner.artistListRelay.value
                            
                            owner.filterArtistList(artistID: subscribedArtistID)
                            owner.showCompleteAlertSubject.onNext(())
                        } catch {
                            // TODO: - 구독시도 이후 에러처리 필수
                        }
                    }
                } else {
                    owner.showLoginAlertSubject.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        let isShowSubscribeButton = subscribeArtistIDList
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
        
        let showLoginAlert = showLoginAlertSubject.asDriver(onErrorDriveWith: .empty())
        let showCompleteAlert = showCompleteAlertSubject.asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isShowSubscribeButton: isShowSubscribeButton,
            showLoginAlert: showLoginAlert,
            showCompleteAlert: showCompleteAlert
        )
    }
}

extension SubscribeArtistViewModel {
    
    /// 구독된 아티스트정보를 가지고 필터하는 함수
    private func filterArtistList(artistID: [String]) {
        var artistList = artistListRelay.value // TODO: - 추후 구독할 아티스트 ID를 API에 넘겨줄 예정
        let filteredArtistList = artistList.filter { artist in
            !artistID.contains(artist.artistName) // FIXME: - 현재 데이터를 구분하는 값 artistName -> artistID로 변경해야함
        }
        artistListRelay.accept(filteredArtistList)
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
        let artistList = artistListRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<ArtistSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(artistList)
        dataSource?.apply(snapshot)
    }
}
