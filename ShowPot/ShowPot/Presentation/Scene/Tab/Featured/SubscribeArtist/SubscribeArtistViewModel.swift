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
    
    var coordinator: SubscribeArtistCoordinator
    var dataSource: DataSource?
    var isLoggedIn: Bool {
        UserDefaultsManager.shared.get(for: .isLoggedIn) ?? false
    }
    
    init(coordinator: SubscribeArtistCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let initializeArtistList: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedArtistCell: Observable<IndexPath>
        let didTappedSubscribeButton: Observable<Void>
    }
    
    struct Output {
        let isShowSubscribeButton: Observable<Bool>
        let showLoginAlert: Observable<Void>
        let showCompleteAlert: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        
        input.initializeArtistList
            .subscribe(with: self) { owner, _ in
                owner.fetchArtistList()
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
                    owner.subscribeArtists()
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
            .asObservable()
        
        let showLoginAlert = showLoginAlertSubject.asObservable()
        let showCompleteAlert = showCompleteAlertSubject.asObservable()
        
        return Output(
            isShowSubscribeButton: isShowSubscribeButton,
            showLoginAlert: showLoginAlert,
            showCompleteAlert: showCompleteAlert
        )
    }
}

extension SubscribeArtistViewModel {
    private func fetchArtistList() { // FIXME: - 추후 API연동해 데이터 수정
        artistListRelay.accept([
            .init(state: .none, artistImageURL: URL(string: "https://storage3.ilyo.co.kr/contents/article/images/2022/1013/1665663228269667.jpg"), artistName: "High Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying BirdHigh Flying Bird"),
            .init(state: .none, artistImageURL: URL(string: "https://i.imgur.com/KsEXGAZ.jpg"), artistName: "Marilia Mendonca"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn.mhns.co.kr/news/photo/201901/157199_206779_07.jpg"), artistName: "The Chainsmokers"),
            .init(state: .none, artistImageURL: URL(string: "https://t3.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/2fG8/image/sxiZQJy0MaesFjfzRRoyNWNRmhM.jpg"), artistName: "Beyonce"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn.redian.org/news/photo/202108/155857_52695_0153.jpg"), artistName: "Adele"),
            .init(state: .none, artistImageURL: URL(string: "https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F1709EC404F290F7720"), artistName: "Imagine Dragons"),
            .init(state: .none, artistImageURL: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAxOTEwMzBfMjM1/MDAxNTcyNDI4Mzg2NjI2.vFBBiLlc8YhPuny8BFHTYczJzoR1ObVC8ZHX2iAGye4g.BVn1BX_bMjbib22Ks-l2VCQUd70yU7o8vNBLcBhSH1gg.PNG.alvin5092/1572428385660.png?type=w800"), artistName: "Maluma"),
            .init(state: .none, artistImageURL: URL(string: "https://i.namu.wiki/i/jrUaXffKzxPCo876eNO8GRdQb81OBQuNV99GnN1pDlXkGcvEsyTJaEtCsWzEtjy4yVoOnPqP058LrPswAh7KQQ.webp"), artistName: "Bruno Mars"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn2.ppomppu.co.kr/zboard/data3/2019/0827/m_20190827133411_lrzretxm.jpg"), artistName: "Leo J"),
            .init(state: .none, artistImageURL: URL(string: "https://cdn.slist.kr/news/photo/201912/122164_224649_5110.jpg"), artistName: "Marco Jacimus")
        ])
        updateDataSource()
    }
    
    private func subscribeArtists() {
        var artistIDs = subscribeArtistIDList.value // TODO: - 추후 구독할 아티스트 ID를 API에 넘겨줄 예정
        
        guard !artistIDs.isEmpty else {
            LogHelper.debug("구독할 아티스트를 선택하고 구독해주세요.")
            return
        }
        var artistList = artistListRelay.value
        // 만약 구독 API성공했다면
        let filteredArtistList = artistList.filter { artist in
            !artistIDs.contains(artist.artistName) // FIXME: - 현재 데이터를 구분하는 값 artistName -> artistID로 변경해야함
        }
        artistListRelay.accept(filteredArtistList)
        subscribeArtistIDList.accept([])
        updateDataSource()
        showCompleteAlertSubject.onNext(())
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
