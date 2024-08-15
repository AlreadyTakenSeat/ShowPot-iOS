//
//  SettingsViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingsViewController: ViewController {
    let viewHolder: SettingsViewHolder = .init()
    let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
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
        setNavigationBarItem(title: Strings.myPageNavigationTitle, rightIcon: .icSetting.withTintColor(.gray400)) // FIXME: - title, rightIcon만 존재하는 경우 inset값 수정 필요
        viewHolder.mypageCollectionView.dataSource = self
        viewHolder.mypageCollectionView.delegate = self
    }
    
    override func bind() {
        
extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        MypageSectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch MypageSectionType.allCases[section] {
        case .menu:
            return viewModel.menuList.count
        case .recentShow:
            return viewModel.recentShowList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch MypageSectionType.allCases[indexPath.section] {
        case .menu:
            let cell = collectionView.dequeueReusableCell(MenuCell.self, for: indexPath) ?? MenuCell()
            let model = viewModel.menuList[indexPath.row]
            cell.configureUI(
                menuImage: model.type.iconImage,
                menuTitle: model.type.title,
                badgeCount: model.badgeCount
            )
            return cell
        case .recentShow:
            let cell = collectionView.dequeueReusableCell(PerformanceInfoCollectionViewCell.self, for: indexPath) ?? PerformanceInfoCollectionViewCell()
            let model = viewModel.recentShowList[indexPath.row]
            cell.configureUI(
                performanceImageURL: model.thumbnailImageURL,
                performanceTitle: model.title,
                performanceTime: model.time,
                performanceLocation: model.location
            )
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyPageHeaderView.reuseIdentifier, for: indexPath) as? MyPageHeaderView ?? MyPageHeaderView()
        headerView.configureUI(userNickname: viewModel.userNickname)
        return headerView
    }
}
