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
        scrollView.backgroundColor = .brown
    }
    
    let contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .lightGray
    }
    
    /// TestView
    let sample1 = UIView().then { view in
        view.backgroundColor = .red
        view.snp.makeConstraints { $0.height.equalTo(500) }
    }
    
    /// TestView
    let sample2 = UIView().then { view in
        view.backgroundColor = .blue
        view.snp.makeConstraints { $0.height.equalTo(100) }
    }
    
    /// TestView
    let sample3 = UIView().then { view in
        view.backgroundColor = .green
        view.snp.makeConstraints { $0.height.equalTo(1000) }
    }
}

extension ShowDetailViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        [sample1, sample2, sample3].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.layoutSubviews()
    }
    
}
