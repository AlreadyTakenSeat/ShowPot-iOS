//
//  GenreSelectViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/4/24.
//

import Foundation
import UIKit

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
        setNavigationBarItem(
            title: Strings.subscribeGenreTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        
        self.hidesBottomBarWhenPushed = true
    }
    
    override func bind() {
        let input = SubscribeGenreViewModel.Input(
            
        )
        
        let output = self.viewModel.transform(input: input)
        
        output.genreList
            .bind(to: self.viewHolder.genreCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                guard let cell = collectionView.dequeueReusableCell(GenreCollectionViewCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.setData(image: item.normalImage)
                return cell
            }
            .disposed(by: disposeBag)
    }
}

extension SubscribeGenreViewController {
    
    private func bindCollectionViewAction() {
        viewHolder.genreCollectionView.rx
            .itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let cell = owner.viewHolder.genreCollectionView.cellForItem(at: indexPath) else {
                    return
                }
            }
            .disposed(by: disposeBag)
        
        viewHolder.genreCollectionView.rx
            .itemDeselected
            .subscribe(with: self) { owner, indexPath in
                guard let cell = owner.viewHolder.genreCollectionView.cellForItem(at: indexPath) else {
                    return
                }
            }
            .disposed(by: disposeBag)
        
    }
}
