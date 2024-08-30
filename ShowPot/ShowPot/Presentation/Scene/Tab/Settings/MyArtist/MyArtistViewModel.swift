//
//  MyArtistViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyArtistViewModel: ViewModelType {
    
    private let usecase: MyArtistUseCase
    private let disposeBag = DisposeBag()
    
    var coordinator: MyArtistCoordinator
    var dataSource: DataSource?
    
    init(coordinator: MyArtistCoordinator, usecase: MyArtistUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    struct Input {
        let didTappedBackButton: Observable<Void>
        let didTappedEmptyViewButton: Observable<Void>
        let didTappedDeleteButton: Observable<IndexPath>
    }
    
    struct Output { 
        let isEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedDeleteButton
            .subscribe(with: self) { owner, indexPath in
                let deleteID = owner.usecase.artistList.value[indexPath.row].id
                LogHelper.debug("삭제하고싶은 아티스트 아이디: \(deleteID)")
                owner.usecase.unsubscribe(artistID: [deleteID])
            }
            .disposed(by: disposeBag)
        
        input.didTappedEmptyViewButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.goToSubscribeArtistScreen()
            }
            .disposed(by: disposeBag)
        
        usecase.unsubscribedArtistID
            .subscribe(with: self) { owner, artistID in
                owner.filterArtistList(artistID: artistID)
            }
            .disposed(by: disposeBag)
        
        usecase.artistList
            .subscribe(with: self) { owner, artistList in
                owner.updateDataSource()
            }
            .disposed(by: disposeBag)
        
        return Output(isEmpty: usecase.artistList.map { $0.isEmpty }.asDriver(onErrorDriveWith: .empty()))
    }
}

extension MyArtistViewModel {
    
    func fetchArtistList() {
        usecase.fetchArtistList()
    }
    
    /// 구독된 아티스트정보를 가지고 필터하는 함수
    private func filterArtistList(artistID: [String]) {
        let artistList = usecase.artistList.value
        let filteredArtistList = artistList.filter { !artistID.contains($0.id) }
        
        usecase.artistList.accept(filteredArtistList)
        updateDataSource()
    }
}

// MARK: - For NSDiffableDataSource

extension MyArtistViewModel {
    
    typealias Item = FeaturedSubscribeArtistCellModel
    typealias DataSource = UICollectionViewDiffableDataSource<MyArtistSection, Item>
    
    /// 구독한 아티스트 섹션 타입
    enum MyArtistSection {
        case main
    }
    
    private func updateDataSource() {
        let artistList = usecase.artistList.value
        var snapshot = NSDiffableDataSourceSnapshot<MyArtistSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(artistList)
        dataSource?.apply(snapshot)
    }
}
