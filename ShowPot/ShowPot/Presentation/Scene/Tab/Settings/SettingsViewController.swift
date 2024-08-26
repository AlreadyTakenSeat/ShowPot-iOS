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
    
    private let didTappedLoginButtonSubject = PublishSubject<Void>()
    
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
        super.bind()
        let input = SettingsViewModel.Input(
            viewDidLoad: .just(()),
            didTappedCell: viewHolder.mypageCollectionView.rx.itemSelected.asObservable(), 
            didTappedSettingButton: contentNavigationBar.didTapRightButton.asObservable(), 
            didTappedLoginButton: didTappedLoginButtonSubject.asObservable()
        )
        viewModel.transform(input: input)
    }
}

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MenuCell.self, for: indexPath) ?? MenuCell()
        let model = viewModel.menuList[indexPath.row]
        cell.configureUI(
            menuImage: model.type.iconImage,
            menuTitle: model.type.title,
            badgeCount: model.badgeCount
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyPageHeaderView.reuseIdentifier, for: indexPath) as? MyPageHeaderView ?? MyPageHeaderView()
        headerView.configureUI(userNickname: viewModel.nickname)
        headerView.alertTextView.delegate = self
        return headerView
    }
}

extension SettingsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == MyPageHeaderView.actionID {
            didTappedLoginButtonSubject.onNext(())
            return false
        }
        return true
    }
}
