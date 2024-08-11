//
//  MyShowAlarmViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/9/24.
//

import UIKit

import RxSwift
import RxGesture

final class MyShowAlarmViewController: ViewController {
    let viewHolder: MyShowAlarmViewHolder = .init()
    let viewModel: MyShowAlarmViewModel
    
    private let didTappedAlarmRemoveButtonSubject = PublishSubject<IndexPath>()
    private let didTappedAlarmUpdateButtonSubject = PublishSubject<IndexPath>()
    
    init(viewModel: MyShowAlarmViewModel) {
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
        setNavigationBarItem(
            title: Strings.myShowNavigationTitle,
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
        viewHolder.myShowCollectionView.delegate = self
    }
    
    override func bind() {
        viewModel.dataSource = makeDataSource()
        
        let input = MyShowAlarmViewModel.Input(
            viewDidLoad: .just(()),
            didTappedBackButton: contentNavigationBar.didTapLeftButton,
            didTappedAlarmRemoveButton: didTappedAlarmRemoveButtonSubject.asObservable(), 
            didTappedAlarmUpdateButton: didTappedAlarmUpdateButtonSubject.asObservable(),
            didTappedShowInfoButton: viewHolder.emptyView.footerButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        output.isEmptyViewHidden
            .map { !$0 }
            .drive(viewHolder.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showTicketingAlarmBottomSheet
            .emit(with: self) { owner, model in
                let updateBottomSheet = TicketingAlarmBottomSheetViewController(viewModel: TicketingAlarmBottomSheetViewModel(showModel: model))
                updateBottomSheet.alarmSettingButton.rx.tap
                    .subscribe(onNext: { _ in
                        updateBottomSheet.dismissBottomSheet()
                    })
                    .disposed(by: owner.disposeBag)
                    
                if let presentedVC = owner.presentedViewController as? AlarmSettingBottomSheetViewController {
                    // 이전 바텀시트가 아직 표시되고 있는 경우, dismiss 후에 새로운 바텀시트를 표시
                    presentedVC.dismissBottomSheet(completion: {
                        owner.presentBottomSheet(viewController: updateBottomSheet)
                    })
                } else {
                    // 이전 바텀시트가 없거나 이미 dismiss된 경우
                    owner.presentBottomSheet(viewController: updateBottomSheet)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyShowAlarmViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 32, height: 80)
    }
}

extension MyShowAlarmViewController {
    func makeDataSource() -> MyShowAlarmViewModel.DataSource {
        let cellRegistration = UICollectionView.CellRegistration<ShowAlarmCell, PerformanceInfoCollectionViewCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
            cell.delegate = self
        }

        let dataSource = UICollectionViewDiffableDataSource<MyShowAlarmViewModel.MyPerformanceSection, PerformanceInfoCollectionViewCellModel>(collectionView: viewHolder.myShowCollectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        return dataSource
    }
}

extension MyShowAlarmViewController: ShowAlarmCellDelegate {
    func didTappedAlarmButton(_ cell: UICollectionViewCell) {
        let indexPath = viewHolder.myShowCollectionView.indexPath(for: cell)
        let settingBottomSheet = AlarmSettingBottomSheetViewController()
        settingBottomSheet.alarmRemoveButton.rx.tap
            .compactMap { indexPath }
            .subscribe(with: self) { owner, indexPath in
                owner.didTappedAlarmRemoveButtonSubject.onNext(indexPath)
                settingBottomSheet.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
        
        settingBottomSheet.alarmUpdateButton.rx.tap
            .compactMap { indexPath }
            .subscribe(with: self) { owner, indexPath in
                settingBottomSheet.dismissBottomSheet()
                owner.didTappedAlarmUpdateButtonSubject.onNext(indexPath)
            }
            .disposed(by: disposeBag)
        
        presentBottomSheet(viewController: settingBottomSheet)
    }
}
