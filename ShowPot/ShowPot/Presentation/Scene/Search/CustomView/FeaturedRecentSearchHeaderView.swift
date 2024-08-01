//
//  FeaturedSearchHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

/// 최근 검색리스트에 대한 헤더뷰
final class FeaturedRecentSearchHeaderView: UICollectionReusableView, ReusableCell {
    
    private let disposeBag = DisposeBag()
    
    var didTappedRemoveAllButton: Observable<Void> {
        removeAllButton.rx.tap.asObservable()
    }
    
    private let recentSearchLabel = SPLabel(KRFont.H2).then {
        $0.textColor = .gray100
        $0.setText(Strings.searchKeywordTitle)
    }
    
    private let removeAllButton = SPButton().then { 
        $0.setText(Strings.searchKeywordButtonTitle, fontType: KRFont.B1_regular)
        $0.configuration?.baseForegroundColor = .gray400
        $0.configuration?.baseBackgroundColor = .clear
        $0.configuration?.contentInsets = .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        [recentSearchLabel, removeAllButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        recentSearchLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.directionalVerticalEdges.equalToSuperview()
        }
        
        removeAllButton.snp.makeConstraints {
            $0.leading.equalTo(recentSearchLabel.snp.trailing)
            $0.directionalVerticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
