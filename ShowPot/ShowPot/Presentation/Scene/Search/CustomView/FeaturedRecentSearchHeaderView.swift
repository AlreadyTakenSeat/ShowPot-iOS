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

final class FeaturedRecentSearchHeaderView: UICollectionReusableView {
    
    static let identifier = String(describing: FeaturedRecentSearchHeaderView.self)
    private let disposeBag = DisposeBag()
    
    var didTappedRemoveAllButton: Observable<Void> {
        removeAllButton.rx.tap.asObservable()
    }
    
    private let recentSearchLabel = UILabel().then {
        $0.text = Strings.searchQueryTitle
        $0.textColor = .gray100
        $0.textAlignment = .left
        $0.font = KRFont.H2
    }
    
    private let removeAllButton = UIButton().then {
        $0.setTitle(Strings.searchQueryButtonTitle, for: .normal)
        $0.setTitleColor(.gray400, for: .normal)
        $0.titleLabel?.font = KRFont.B1_regular
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
            $0.width.equalTo(59)
        }
    }
}
