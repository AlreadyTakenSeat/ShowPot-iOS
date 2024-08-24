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
    }
    
    override func setupStyles() {
        super.setupStyles()
        
        self.setNavigationBarItem(title: Strings.showDetailTitle, leftIcon: .icArrowLeft.withTintColor(.gray000))
        self.contentNavigationBar.titleLabel.textColor = .gray000
        self.contentNavigationBar.backgroundColor = .clear
    }
        
    override func bind() {
        
        viewHolder.seatInfoView.showSeatListView.delegate = self
        
        viewHolder.footerView.alarmButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let isAlarmUpdatedBefore = owner.viewHolder.footerView.alarmButton.isSelected
                
                if isAlarmUpdatedBefore {
                    let alarmBottmSheet = TicketingAlarmUpdateBottomSheetViewController(viewModel: TicketingAlarmUpdateViewModel(showID: owner.viewModel.showID, usecase: MyShowAlarmUseCase()))
                    alarmBottmSheet.alarmSettingButton.rx.tap
                        .subscribe(onNext: { _ in
                            alarmBottmSheet.dismissBottomSheet()
                        })
                        .disposed(by: owner.disposeBag)
                    owner.presentBottomSheet(viewController: alarmBottmSheet)
                } else {
                    let alarmBottmSheet = TicketingAlarmBottomSheetViewController(viewModel: TicketingAlarmViewModel(showID: owner.viewModel.showID, usecase: MyShowAlarmUseCase()))
                    alarmBottmSheet.alarmSettingButton.rx.tap
                        .subscribe(onNext: { _ in
                            alarmBottmSheet.dismissBottomSheet()
                        })
                        .disposed(by: owner.disposeBag)
                    owner.presentBottomSheet(viewController: alarmBottmSheet)
                }
            }
            .disposed(by: disposeBag)
        
        let input = ShowDetailViewModel.Input(
            viewDidLoad: .just(()),
            didTappedLikeButton: viewHolder.footerView.likeButton.rx.tap.asObservable(), 
            didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.showOverview
            .subscribe(with: self) { owner, model in
                guard let showTime = model.time else { return }
                owner.viewHolder.posterImageView.setImage(urlString: model.posterImageURLString, option: .relativeHeight)
                owner.viewHolder.titleView.titleLabel.setText(model.title)
                owner.viewHolder.infoView.setData(date: DateFormatterFactory.dateWithDot.string(from: showTime), location: model.location)
            }
            .disposed(by: disposeBag)
        
        output.ticketBrandList
            .bind(to: viewHolder.ticketInfoView.ticketSaleCollectionView.rx.items(
                cellIdentifier: TicketSaleCollectionViewCell.reuseIdentifier,
                cellType: TicketSaleCollectionViewCell.self)
            ) { index, item, cell in
                let brand = TicketSaleBrand(rawValue: item) ?? TicketSaleBrand.other
                cell.setData(title: brand.title ?? item, color: brand.color)
            }
            .disposed(by: disposeBag)
        
        output.ticketTimeInfo
            .subscribe(with: self) { owner, result in
                let (preDescription, normalDescription) = result
                guard let preDescription = preDescription,
                      let normalDescription = normalDescription else { return }
                owner.viewHolder.ticketInfoView.preTicketSaleView.setData(description: DateFormatterFactory.dateWithTicketing.string(from: preDescription))
                owner.viewHolder.ticketInfoView.normalTicketSaleView.setData(description: DateFormatterFactory.dateWithTicketing.string(from: normalDescription))
            }
            .disposed(by: disposeBag)
        
        output.artistList
            .bind(to: viewHolder.artistInfoView.artistCollectionView.rx.items(
                cellIdentifier: FeaturedSubscribeArtistCell.reuseIdentifier,
                cellType: FeaturedSubscribeArtistCell.self)
            ) { index, item, cell in
                cell.configureUI(state: item.state, artistImageURL: item.artistImageURL, artistName: item.artistName)
            }
            .disposed(by: disposeBag)
        
        output.genreList
            .bind(to: viewHolder.genreInfoView.showGenreListView.rx.items(
                cellIdentifier: ShowGenreCell.reuseIdentifier,
                cellType: ShowGenreCell.self)
            ) { index, item, cell in
                cell.configureUI(with: item.rawValue)
            }
            .disposed(by: disposeBag)
        
        output.seatList
            .bind(to: viewHolder.seatInfoView.showSeatListView.rx.items(
                cellIdentifier: ShowSeatCell.reuseIdentifier,
                cellType: ShowSeatCell.self)
            ) { index, item, cell in
                cell.configureUI(seatCategory: item.seatCategoryTitle, seatPrice: item.seatPrice)
            }
            .disposed(by: disposeBag)
        
        output.isLikeButtonSelected
            .subscribe(viewHolder.footerView.likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.alarmButtonState
            .subscribe(with: self) { owner, result in
                let (isUpdatedBefore, isEnabled) = result
                if !isEnabled {
                    owner.viewHolder.footerView.alarmButton.isEnabled = isEnabled
                    return
                }
                owner.viewHolder.footerView.alarmButton.isSelected = isUpdatedBefore
            }
            .disposed(by: disposeBag)
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
