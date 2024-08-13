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
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 6, left: .zero, bottom: .zero, right: .zero)
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
        $0.register(MyAlarmMenuCell.self)
        $0.backgroundColor = .gray700
        $0.isScrollEnabled = false
    }
    
}

extension SavedViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        [ticketingHeaderView, upcomingCarouselView, menuCollectionView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        
        scrollView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        ticketingHeaderView.snp.makeConstraints {
            $0.height.equalTo(90 + 36)
        }
        
        upcomingCarouselView.snp.makeConstraints {
            $0.height.equalTo(368)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.height.equalTo(156)
        }
        
        containerStackView.setCustomSpacing(23, after: ticketingHeaderView)
    }
}

