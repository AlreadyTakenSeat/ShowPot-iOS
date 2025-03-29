//
//  ShowDetailInfoView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/13/24.
//

import UIKit
import SnapKit
import Then

final class ShowDetailInfoView: UIView {
    
    lazy var contentStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    lazy var dateLabelStack = ShowDetailLabelStackView(title: Strings.showDate)
    lazy var locationLabelStack = ShowDetailLabelStackView(title: Strings.showLoaction)
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [dateLabelStack, locationLabelStack].forEach { contentStackView.addArrangedSubview($0) }
    }
}

extension ShowDetailInfoView {
    func setData(date: String, location: String) {
        self.dateLabelStack.setData(description: date)
        self.locationLabelStack.setData(description: location)
    }
}
