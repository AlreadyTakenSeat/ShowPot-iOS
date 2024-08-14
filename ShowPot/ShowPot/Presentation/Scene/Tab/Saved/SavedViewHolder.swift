//
//  SavedViewHolder.swift
//  ShowPot
//
//  Created by Daegeon Choi on 6/28/24.
//

import UIKit

import ScalingCarousel
import SnapKit
import Then

final class SavedViewHolder {
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
    }
    
    private let titleLabel = SPLabel(KRFont.H1).then {
        $0.textColor = .gray300
        $0.setText(Strings.myAlarmMainTitle)
    }
    
    let ticketingHeaderView = MyUpcomingTicketingHeaderView()
    
    lazy var upcomingCarouselView = ScalingCarouselView(withFrame: .zero, andInset: 66).then {
        $0.register(MyUpcomingTicketingCell.self)
        $0.backgroundColor = .gray700
    }
    
    private let menuCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 12
    }
    
    lazy var menuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: menuCollectionViewLayout).then {
        $0.register(MenuCell.self)
        $0.backgroundColor = .gray700
        $0.isScrollEnabled = false
    }
    
    lazy var emptyView = MyAlarmEmptyView()
    
}

extension SavedViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(scrollView)
        [titleLabel, containerStackView, emptyView].forEach { scrollView.addSubview($0) }
        [ticketingHeaderView, upcomingCarouselView, menuCollectionView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        
        scrollView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(menuCollectionView.snp.top)
        }
        
        ticketingHeaderView.snp.makeConstraints {
            $0.height.equalTo(45 + 36)
        }
        
        upcomingCarouselView.snp.makeConstraints {
            $0.height.equalTo(368)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.height.equalTo(156)
        }

        containerStackView.setCustomSpacing(24, after: ticketingHeaderView)
        containerStackView.setCustomSpacing(23, after: upcomingCarouselView)
    }
}
