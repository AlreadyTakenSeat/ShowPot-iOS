//
//  ShowDetailViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit
import RxSwift

class ShowDetailViewController: ViewController {
    
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
        // TODO: #106 ViewHolder 개발 완료 후 ViewModel 사용하여 데이터 주입
        viewHolder.posterImageView.setImage(urlString: "https://enfntsterribles.com/wp-content/uploads/2023/08/enfntsterribles-nothing-but-thieves-01.jpg", option: .relativeHeight)
        viewHolder.titleView.titleLabel.setText("나씽 벗 띠브스 내한공연 (Nothing But Thieves Live in Seoul)")
        viewHolder.infoView.setData(date: "2024.08.21", location: "KBS 아레나홀")
        viewHolder.ticketInfoView.preTicketSaleView.setData(description: "6월 20일 (목) 12:00")
        viewHolder.ticketInfoView.normalTicketSaleView.setData(description: "6월 21일 (금) 18:00")
        
        viewHolder.ticketInfoView.ticketSaleCollectionView.delegate = self
        viewHolder.genreInfoView.showGenreListView.delegate = self
        
        let input = ShowDetailViewModel.Input(viewDidLoad: .just(()))
        let output = viewModel.transform(input: input)
        
        output.ticketList
            .bind(to: viewHolder.ticketInfoView.ticketSaleCollectionView.rx.items(
                cellIdentifier: TicketSaleCollectionViewCell.reuseIdentifier,
                cellType: TicketSaleCollectionViewCell.self)
            ) { index, item, cell in
                let brand = TicketSaleBrand(rawValue: item) ?? TicketSaleBrand.other
                cell.setData(title: brand.title ?? item, color: brand.color)
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
    }
}

extension ShowDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // TODO: #135 self sizing cell 구현
        if collectionView == viewHolder.ticketInfoView.ticketSaleCollectionView {
            return CGSize(width: 80, height: 30)
        } else if collectionView == viewHolder.genreInfoView.showGenreListView {
            let label = SPLabel(KRFont.B1_regular).then {
                $0.setText(viewModel.genreList[indexPath.row].rawValue)
                $0.sizeToFit()
            }
            let size = label.frame.size
            let additionalWidth: CGFloat = 14 + 14
            let width = additionalWidth + size.width
            return CGSize(width: width, height: 40)
        }
        return .zero
    }
}
