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
}

extension ShowDetailViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        let subViews = [posterImageView, titleView, infoView, ticketInfoView]
        contentStackView.addArrangedDividerSubViews(subViews, ecxlude: [0])
    }
    
    func configureConstraints(for view: UIView) {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}
