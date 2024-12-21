//
//  ShowDetailViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit
import RxSwift

final class ShowDetailViewController: ViewController {
    
    let viewHolder: ShowDetailViewHolder = .init()
    let viewModel: ShowDetailViewModel
    
    init(viewModel: ShowDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.useSafeArea = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
        viewHolder.seatInfoView.showSeatListView.delegate = self
    }
    
    override func setupStyles() {
        super.setupStyles()
        self.setNavigationBarItem(title: Strings.showDetailTitle, leftIcon: .icArrowLeft.withTintColor(.gray000))
        self.contentNavigationBar.titleLabel.textColor = .gray000
        self.contentNavigationBar.backgroundColor = .clear
    }
    
    override func bind() {
        viewHolder.footerView.alarmButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let isAlarmUpdatedBefore = owner.viewHolder.footerView.alarmButton.isSelected
                
                guard owner.viewModel.isLoggedIn else {
                    owner.showLoginBottomSheet()
                    return
                }
                
                owner.showAlarmBottomSheet(isAlarmUpdatedBefore: isAlarmUpdatedBefore)
            }
            .disposed(by: disposeBag)
        
        let input = ShowDetailViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in Void() },
            didTappedLikeButton: viewHolder.footerView.likeButton.rx.tap.asObservable().map { self.viewHolder.footerView.likeButton.state },
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable(),
            didTappedTicketingCell: viewHolder.ticketInfoView.ticketSaleCollectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        bindShowDetailInfo(output)
        bindButtonState(output)
        
        output.showLoginBottomSheet
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.showLoginBottomSheet()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindButtonState(_ output: ShowDetailViewModel.Output) {
        output.isLikeButtonSelected
            .asDriver(onErrorDriveWith: .empty())
            .drive(viewHolder.footerView.likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.alarmButtonState
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, result in
                let (isUpdatedBefore, isAlreadyOpen) = result
                guard !isAlreadyOpen else {
                    owner.viewHolder.footerView.alarmButton.isEnabled = false
                    return
                }
                owner.viewHolder.footerView.alarmButton.isSelected = isUpdatedBefore
            }
            .disposed(by: disposeBag)
    }
    
    private func bindShowDetailInfo(_ output: ShowDetailViewModel.Output) {
        output.showOverview
            .asDriver()
            .drive(with: self) { owner, model in
                guard let showTime = model.time else { return }
                owner.viewHolder.posterImageView.setImage(urlString: model.posterImageURLString, option: .relativeHeight)
                owner.viewHolder.titleView.titleLabel.setText(model.title)
                owner.viewHolder.infoView.setData(date: DateFormatterFactory.dateWithDot.string(from: showTime), location: model.location)
            }
            .disposed(by: disposeBag)
        
        output.ticketBrandModel
            .asDriver(onErrorJustReturn: [])
            .drive(viewHolder.ticketInfoView.ticketSaleCollectionView.rx.items(
                cellIdentifier: TicketSaleCollectionViewCell.reuseIdentifier,
                cellType: TicketSaleCollectionViewCell.self)
            ) { index, item, cell in
                let brand = TicketSaleBrand(rawValue: item) ?? TicketSaleBrand.other
                cell.setData(title: brand.title ?? item, color: brand.color)
            }
            .disposed(by: disposeBag)
        
        output.ticketTimeInfo
            .asDriver()
            .drive(with: self) { owner, result in
                let (preDescription, normalDescription) = result
                if let normalDescription = normalDescription {
                    owner.viewHolder.ticketInfoView.normalTicketSaleView.setData(description: DateFormatterFactory.dateWithTicketing.string(from: normalDescription))
                }
                
                if let preDescription = preDescription {
                    owner.viewHolder.ticketInfoView.preTicketSaleView.setData(description: DateFormatterFactory.dateWithTicketing.string(from: preDescription))
                }
            }
            .disposed(by: disposeBag)
        
        output.artistModel
            .asDriver(onErrorJustReturn: [])
            .drive(viewHolder.artistInfoView.artistCollectionView.rx.items(
                cellIdentifier: FeaturedSubscribeArtistCell.reuseIdentifier,
                cellType: FeaturedSubscribeArtistCell.self)
            ) { index, item, cell in
                cell.configureUI(state: item.state, artistImageURL: item.artistImageURL, artistName: item.artistName)
            }
            .disposed(by: disposeBag)
        
        output.genreModel
            .asDriver(onErrorJustReturn: [])
            .drive(viewHolder.genreInfoView.showGenreListView.rx.items(
                cellIdentifier: ShowGenreCell.reuseIdentifier,
                cellType: ShowGenreCell.self)
            ) { index, item, cell in
                cell.configureUI(with: item.rawValue)
            }
            .disposed(by: disposeBag)
        
        output.seatModel
            .asDriver(onErrorJustReturn: [])
            .drive(viewHolder.seatInfoView.showSeatListView.rx.items(
                cellIdentifier: ShowSeatCell.reuseIdentifier,
                cellType: ShowSeatCell.self)
            ) { index, item, cell in
                cell.configureUI(
                    seatCategory: item.seatCategoryTitle,
                    seatPrice: NumberformatterFactory.decimal.string(from: item.seatPrice ?? 0)
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlarmBottomSheet(isAlarmUpdatedBefore: Bool) {
        if isAlarmUpdatedBefore {
            let alarmBottmSheet = TicketingAlarmUpdateBottomSheetViewController(
                viewModel: TicketingAlarmUpdateViewModel(
                    showID: viewModel.showID,
                    usecase: MyShowAlarmUseCase()
                )
            )
            alarmBottmSheet.successAlarmUpdateSubject
                .subscribe(with: self) { owner, _ in
                    SPSnackBar(contextView: owner.view, type: .alarm)
                        .show()
                }
                .disposed(by: disposeBag)
            presentBottomSheet(viewController: alarmBottmSheet)
        } else {
            let alarmBottmSheet = TicketingAlarmBottomSheetViewController(
                viewModel: TicketingAlarmViewModel(
                    showID: viewModel.showID,
                    usecase: MyShowAlarmUseCase()
                )
            )
            alarmBottmSheet.successAlarmUpdateSubject
                .subscribe(with: self) { owner, _ in
                    SPSnackBar(contextView: owner.view, type: .alarm)
                        .show()
                }
                .disposed(by: disposeBag)
            presentBottomSheet(viewController: alarmBottmSheet)
        }
    }
}

extension ShowDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // TODO: #135 self sizing cell 구현
        if collectionView == viewHolder.seatInfoView.showSeatListView {
            return .init(width: collectionView.frame.width - 24, height: 24)
        }
        return .zero
    }
}
