//
//  TicketingAlarmBottomSheetViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/24/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class TicketingAlarmBottomSheetViewController: BottomSheetViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: TicketingAlarmViewModel
    
    private let titleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray100
        $0.setText(Strings.myShowTicketBottomsheetTitle)
    }
    
    private let ticketingAlarmCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 16, left: 16, bottom: 20, right: 16)
        $0.minimumLineSpacing = 12
        $0.scrollDirection = .vertical
    }
    
    private lazy var ticketingAlarmCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ticketingAlarmCollectionViewLayout).then {
        $0.register(TicketingAlarmCell.self)
        $0.backgroundColor = .gray600
        $0.delegate = self
    }
    
    let alarmSettingButton = SPButton(fontType: KRFont.H2).then {
        $0.configurationUpdateHandler = $0.configuration?.enabledToggleButton(label: Strings.showDetailBottomButtonTitle)
    }
    
    init(viewModel: TicketingAlarmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupStyles()
        setupLayouts()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        contentView.backgroundColor = .gray600
    }
    
    private func setupLayouts() {
        [titleLabel, ticketingAlarmCollectionView, alarmSettingButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        ticketingAlarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(225)
        }
        
        alarmSettingButton.snp.makeConstraints {
            $0.top.equalTo(ticketingAlarmCollectionView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(55)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func bind() {
        
        viewModel.dataSource = makeDataSource()
        
        let input = TicketingAlarmViewModel.Input(
            viewDidLoad: .just(()),
            didTappedTicketingTimeCell: ticketingAlarmCollectionView.rx.itemSelected.asObservable(),
            didTappedUpdateButton: alarmSettingButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.isEnabledBottomButton
            .drive(alarmSettingButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
}

extension TicketingAlarmBottomSheetViewController {
    func makeDataSource() -> TicketingAlarmViewModel.DataSource {
        let cellRegistration = UICollectionView.CellRegistration<TicketingAlarmCell, TicketingAlarmCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }

        let dataSource = UICollectionViewDiffableDataSource<TicketingAlarmViewModel.TicketingAlarmSection, TicketingAlarmCellModel>(collectionView: ticketingAlarmCollectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        return dataSource
    }
}

extension TicketingAlarmBottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 32, height: 55)
    }
}
