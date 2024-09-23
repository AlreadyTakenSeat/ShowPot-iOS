//
//  MyAlarmListViewController.swift
//  ShowPot
//
//  Created by 이건준 on 9/23/24.
//

import Foundation

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
    }

    override func setupStyles() {

    }

    override func bind() {

    }
}
