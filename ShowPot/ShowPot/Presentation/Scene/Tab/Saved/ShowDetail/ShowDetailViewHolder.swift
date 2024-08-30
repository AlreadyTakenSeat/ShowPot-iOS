//
//  ShowDetailViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit
import SnapKit
import Then

final class ShowDetailViewHolder {
    
    let scrollView = UIScrollView().then { scrollView in
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = true
    }
    
    let contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
    }
    
    lazy var posterImageView = ShowDetailPosterImageView()
    lazy var titleView = ShowDetailTitleView()
    lazy var infoView = ShowDetailInfoView()
    lazy var ticketInfoView = ShowDetailTicketInfoView()
    lazy var artistInfoView = ShowDetailArtistInfoView()
    lazy var seatInfoView = ShowDetailSeatInfoView()
    lazy var genreInfoView = ShowDetailGenreInfoView()
    lazy var footerView = ShowDetailFooterView()
}

extension ShowDetailViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        
        [scrollView, footerView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStackView)

        let subViews = [posterImageView, titleView, infoView, ticketInfoView, artistInfoView, seatInfoView, genreInfoView]
        contentStackView.addArrangedDividerSubViews(subViews, ecxlude: [0, 6])
    }
    
    func configureConstraints(for view: UIView) {
        
        footerView.snp.makeConstraints {
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(118)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}
