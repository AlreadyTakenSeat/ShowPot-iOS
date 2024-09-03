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
    
    private let refreshTrigger = PublishSubject<Void>()
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTrigger.onNext(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func bind() {
        super.bind()
        let input = SettingViewModel.Input(
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable(),
            didTappedSettingCell: viewHolder.settingListView.rx.itemSelected.asObservable(), 
            refreshSettings: refreshTrigger.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.versionDescription
            .subscribe(with: self) { owner, result in
                let (row, description) = result
                let versionIndexPath = IndexPath(row: row, section: 0)
                guard let firstCell = owner.viewHolder.settingListView.cellForItem(at: versionIndexPath) as? LabelMenuCell else { return }
                firstCell.configureUI(description: description)
            }
            .disposed(by: disposeBag)
        
        // TODO: - 추후 RxDataSources로 리팩토링 필요
        output.settingModel
            .bind(to: viewHolder.settingListView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                
                if item == .version {
                    let labelMenuCell = collectionView.dequeueReusableCell(LabelMenuCell.self, for: indexPath) ?? LabelMenuCell()
                    labelMenuCell.configureUI(
                        menuImage: item.iconImage,
                        menuTitle: item.title
                    )
                    return labelMenuCell
                } else {
                    let cell = collectionView.dequeueReusableCell(MenuCell.self, for: indexPath) ?? MenuCell()
                    cell.configureUI(
                        menuImage: item.iconImage,
                        menuTitle: item.title
                    )
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func setupStyles() {
        super.setupStyles()
        setNavigationBarItem(
            title: Strings.settingNavigationTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        contentNavigationBar.titleLabel.textColor = .gray300
        viewHolder.settingListView.delegate = self
    }
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 44)
    }
}
