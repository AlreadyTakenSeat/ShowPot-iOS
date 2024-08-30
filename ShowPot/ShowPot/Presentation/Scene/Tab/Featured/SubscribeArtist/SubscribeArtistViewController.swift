//
//  SubscribeArtistViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit

final class SubscribeArtistViewController: ViewController {
    let viewHolder: SubscribeArtistViewHolder = .init()
    let viewModel: SubscribeArtistViewModel
    
    init(viewModel: SubscribeArtistViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func setupStyles() {
        super.setupStyles()
        viewHolder.artistCollectionView.delegate = self
        setNavigationBarItem(
            title: Strings.subscribeArtistNavigationTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000),
            rightIcon: nil
        )
    }
    
    override func bind() {
        viewModel.dataSource = makeDataSource()
        
        let input = SubscribeArtistViewModel.Input(
            viewDidLoad: .just(()),
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable(),
            didTappedArtistCell: viewHolder.artistCollectionView.rx.itemSelected.asObservable(),
            didTappedSubscribeButton: viewHolder.subscribeFooterView.bottomButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        output.isShowSubscribeButton
            .skip(1)
            .drive(with: self) { owner, isShow in
                isShow ? owner.viewHolder.showButton() : owner.viewHolder.dismissButton()
            }
            .disposed(by: disposeBag)
        
        output.showLoginAlert
            .drive(with: self) { owner, _ in
                owner.showLoginBottomSheet()
            }
            .disposed(by: disposeBag)
        
        output.subscribeArtistResult
            .subscribe(with: self) { owner, isSuccess in
                owner.showAddSubscribtionSnackbar(isSuccess: isSuccess)
            }
            .disposed(by: disposeBag)
    }
}

extension SubscribeArtistViewController {
    private func showAddSubscribtionSnackbar(isSuccess: Bool) {
        guard isSuccess else { return }
        
        SPSnackBar(contextView: self.view, type: .subscribe)
            .setAction(with: Strings.snackbarActionTitle) {
                
            }
            .show()
    }
}

extension SubscribeArtistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 100, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        (collectionView.frame.width - 27 * 2 - 100 * 3) / 2
    }
}

extension SubscribeArtistViewController {
    func makeDataSource() -> SubscribeArtistViewModel.DataSource {
        let cellRegistration = UICollectionView.CellRegistration<FeaturedSubscribeArtistCell, FeaturedSubscribeArtistCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<SubscribeArtistViewModel.ArtistSection, FeaturedSubscribeArtistCellModel>(collectionView: viewHolder.artistCollectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        return dataSource
    }
}
