//
//  SettingViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingViewController: ViewController {
    let viewHolder: SettingViewHolder = .init()
    let viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
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
    
    override func bind() {
        super.bind()
        let input = SettingViewModel.Input(
            viewDidLoad: .just(()),
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable(),
            didTappedSettingCell: viewHolder.settingListView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.versionAlertMessage
            .emit(with: self) { owner, message in
                let firstIndexPath = IndexPath(row: 0, section: 0)
                guard let firstCell = owner.viewHolder.settingListView.cellForItem(at: firstIndexPath) as? LabelMenuCell else { return }
                firstCell.configureUI(menuAlert: message)
            }
            .disposed(by: disposeBag)
    }
    
    override func setupStyles() {
        super.setupStyles()
        setNavigationBarItem(
            title: "설정",
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        viewHolder.settingListView.delegate = self
        viewHolder.settingListView.dataSource = self
    }
}

extension SettingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.settingModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.settingModel[indexPath.row]
        if model == .version {
            let cell = collectionView.dequeueReusableCell(LabelMenuCell.self, for: indexPath) ?? LabelMenuCell()
            cell.configureUI(
                menuImage: model.iconImage,
                menuTitle: model.title
            )
            return cell
        }
        let cell = collectionView.dequeueReusableCell(MenuCell.self, for: indexPath) ?? MenuCell()
        cell.configureUI(
            menuImage: model.iconImage,
            menuTitle: model.title
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 44)
    }
}

