//
//  ShowDetailTitleView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/13/24.
//

import UIKit
import SnapKit
import Then

final class ShowDetailTitleView: UIView {
    
    lazy var titleLabel = SPLabel(ENFont.H0).then { label in
        label.numberOfLines = 0
        label.textColor = .gray000
    }
    
    init() {
        super.init(frame: .zero)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShowDetailTitleView {
    
    private func setUpLayout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
