//
//  SPDividerView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/15/24.
//

import UIKit
import SnapKit

class SPDividerView: UIView {
    
    lazy var lineView = UIView().then { view in
        view.backgroundColor = .gray500
    }
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 10000, height: 1))
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension UIStackView {
    
    func addArrangedDividerSubViews(_ views: [UIView], ecxlude: [Int]? = []) {
        self.addArrangedSubviews(views, ecxlude ?? [], divier: { SPDividerView() })
    }
}
