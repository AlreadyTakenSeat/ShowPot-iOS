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
    }
    
    override func setupStyles() {
        setNavigationBarItem(
            title: Strings.subscribeGenreTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
    }
    
    override func bind() {
        let input = SubscribeGenreViewModel.Input(
            viewInit: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }
        )
        
        let output = self.viewModel.transform(input: input)
        output.genreList
            .bind(to: self.viewHolder.genreCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
                cell.backgroundColor = .red
                return cell
            }
            .disposed(by: disposeBag)
    }
}
