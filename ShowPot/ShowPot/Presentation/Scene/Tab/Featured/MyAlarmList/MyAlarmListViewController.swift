//
//  MyAlarmListViewController.swift
//  ShowPot
//
//  Created by 이건준 on 9/23/24.
//

import UIKit

final class MyAlarmListViewController: ViewController {
    let viewHolder: MyAlarmListViewHolder = .init()
    let viewModel: MyAlarmListViewModel

    init(viewModel: MyAlarmListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil) 
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
        
        viewHolder.alarmListView.delegate = self
    }

    override func setupStyles() {
        super.setupStyles()
        setNavigationBarItem(
            title: Strings.myAlarmListNavigationTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
    }

    override func bind() {
        
    }
}

extension MyAlarmListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 32, height: 80)
    }
}
