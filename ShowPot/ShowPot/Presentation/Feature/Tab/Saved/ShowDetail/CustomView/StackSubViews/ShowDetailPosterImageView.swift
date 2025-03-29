//
//  ShowDetailPosterImageView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/13/24.
//

import UIKit
import SnapKit
import Then

final class ShowDetailPosterImageView: UIImageView {
    
    lazy var topShadowView = GradientView(
        colors: [
            .gray800.withAlphaComponent(0.5),
            .gray800.withAlphaComponent(0.0)
        ],
        startPoint: .init(x: 0.5, y: 0.0),
        endPoint: .init(x: 0.5, y: 1.0)
    )
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShowDetailPosterImageView {
    
    private func setUpView() {
        self.contentMode = .scaleAspectFit
        self.snp.makeConstraints { make in
            make.height.equalTo(524)
        }
        
        self.addSubview(topShadowView)
        topShadowView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(153)
        }
    }
}
