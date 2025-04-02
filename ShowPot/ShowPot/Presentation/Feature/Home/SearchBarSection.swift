//
//  SearchBarSection.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchBarSection: UICollectionViewCell {
    let textField = SPTextField(placeholder: "관심 있는 공연과 가수를 검색해보세요")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
