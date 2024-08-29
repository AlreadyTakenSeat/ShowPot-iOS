//
//  AccountViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import UIKit

final class AccountViewController: ViewController {
    let viewHolder: AccountViewHolder = .init()
    let viewModel: AccountViewModel
    
    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        super.setupStyles()
        viewHolderConfigure()
        
        viewHolder.accountCollectionView.delegate = self
        viewHolder.accountCollectionView.dataSource = self
        
        setNavigationBarItem(
            title: "계정",
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        contentNavigationBar.titleLabel.textColor = .gray300
    }
    
    override func bind() {
        super.bind()
        
        let input = AccountViewModel.Input(
            viewDidLoad: .just(()),
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable(),
            didTappedCell: viewHolder.accountCollectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
    }
}

extension AccountViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MenuCell.self, for: indexPath) ?? MenuCell()
        let model = viewModel.menuList[indexPath.row]
        cell.configureUI(
            menuImage: model.iconImage,
            menuTitle: model.title
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AccountHeaderView.reuseIdentifier, for: indexPath) as? AccountHeaderView ?? AccountHeaderView()
        headerView.configureUI(
            nickname: viewModel.isLoggedIn ? "춤추는 고래" : "",
            socialType: "카카오 로그인"
        ) // TODO: - 추후 실제 닉네임데이터로 교체해야함
        return headerView
    }
}
