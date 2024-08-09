//
//  GenreSelectViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import UIKit
import RxSwift

class SubscribeGenreViewController: ViewController {
    let viewHolder: SubscribeGenreViewHolder = .init()
    let viewModel: SubscribeGenreViewModel
    
    init(viewModel: SubscribeGenreViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
        bindCollectionViewAction()
    }
    
    override func setupStyles() {
        super.setupStyles()
        setNavigationBarItem(
            title: Strings.subscribeGenreTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        
        self.hidesBottomBarWhenPushed = true
    }
    
    override func bind() {
        let input = SubscribeGenreViewModel.Input(
            didTapBottomButton: PublishSubject<GenreActionType>()
        )
        
        bindCollectionViewAction(input: input)
        
        let output = self.viewModel.transform(input: input)
        
        output.genreList
            .bind(to: viewHolder.genreCollectionView.rx.items(
                cellIdentifier: GenreCollectionViewCell.reuseIdentifier,
                cellType: GenreCollectionViewCell.self)
            ) { index, item, cell in
                cell.isHighlighted = item.isSubscribed
                cell.setData(genre: item.genre)
            }
            .disposed(by: disposeBag)
    }
}

extension SubscribeGenreViewController {
    
    private func bindCollectionViewAction(input: SubscribeGenreViewModel.Input) {
        
        let collectionView = viewHolder.genreCollectionView
        
        let cellStateObservable = Observable.merge(
            collectionView.rx.itemSelected.asObservable(),
            collectionView.rx.itemDeselected.asObservable()
        )
        
        let cellModelObservable = Observable.merge(
            collectionView.rx.modelSelected(GenreState.self).asObservable(),
            collectionView.rx.modelDeselected(GenreState.self).asObservable()
        )
        
        Observable.zip(cellStateObservable, cellModelObservable)
            .subscribe { [weak self] indexPath, model in
                guard let self = self,
                      let cell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell else {
                    return
                }
                
                if self.viewModel.isLoggedIn == false {
                    self.showLoginBottomSheet()
                    cell.isSelected = false
                }
                
                if model.isSubscribed {
                    let cancelSubscribeSheet = SPDefaultBottomSheetViewController(
                        message: "\(model.genre.rawValue) 구독 취소 하시겠습니까?",
                        buttonTitle: "구독 취소하기"
                    )
                    
                    cancelSubscribeSheet.didTapBottomButton
                        .map { model.genre }
                        .bind(to: input.didTapDeleteSubscribeButton)
                        .disposed(by: self.disposeBag)
                    
                    self.presentBottomSheet(viewController: cancelSubscribeSheet)
                    return
                }
            
            cell.setData(genre: model.genre)
            
        }.disposed(by: disposeBag)
    }
}
