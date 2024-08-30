//
//  MyArtistViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import UIKit

import RxSwift

final class MyArtistViewController: ViewController {
    let viewHolder: MyArtistViewHolder = .init()
    let viewModel: MyArtistViewModel
    
    private let didTappedDeleteButtonSubject = PublishSubject<IndexPath>()
    
    init(viewModel: MyArtistViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchArtistList()
    }
    
    override func setupStyles() {
        super.setupStyles()
        viewHolderConfigure()
        viewHolder.artistCollectionView.delegate = self
        setNavigationBarItem(
            title: Strings.myArtistNavigationTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000),
            rightIcon: nil
        )
        contentNavigationBar.titleLabel.textColor = .gray300
    }
    
    override func bind() {
        super.bind()
        
        viewModel.dataSource = makeDataSource()
        
        let input = MyArtistViewModel.Input(
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable(), 
            didTappedEmptyViewButton: viewHolder.emptyView.footerButton.rx.tap.asObservable(), 
            didTappedDeleteButton: didTappedDeleteButtonSubject.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.isEmpty
            .map { !$0 }
            .drive(viewHolder.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension MyArtistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 100, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        (collectionView.frame.width - 25 * 2 - 100 * 3) / 2
    }
}

extension MyArtistViewController {
    func makeDataSource() -> MyArtistViewModel.DataSource {
        let cellRegistration = UICollectionView.CellRegistration<DeleteArtistCell, FeaturedSubscribeArtistCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
            cell.delegate = self
        }
        
        let dataSource = UICollectionViewDiffableDataSource<MyArtistViewModel.MyArtistSection, FeaturedSubscribeArtistCellModel>(collectionView: viewHolder.artistCollectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        return dataSource
    }
}

extension MyArtistViewController: DeleteArtistCellDelegate {
    func didTappedDeleteButton(_ cell: UICollectionViewCell) {
        guard let index = viewHolder.artistCollectionView.indexPath(for: cell) else { return }
        didTappedDeleteButtonSubject.onNext(index)
    }
}
