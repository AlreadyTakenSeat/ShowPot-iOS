//
//  SPDividerReusableView.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import UIKit
import SnapKit

final class SPDividerReusableView: UICollectionReusableView {
    private let divider: SPDivider
    
    override init(frame: CGRect) {
        divider = SPDivider(style: .long) // 기본적으로 short 스타일 사용
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Views
private extension SPDividerReusableView {
    func configureUI() {
        backgroundColor = .clear
        addSubview(divider)
    }
    
    func configureLayout() {
        divider.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let view = SPDividerReusableView()
    return view
}
