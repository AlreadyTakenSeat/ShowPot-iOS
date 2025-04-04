//
//  SPChipCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/3/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SPChipCell: UICollectionViewCell {
    let chipButton = SPChip(title: "", style: .cancel)
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(chipButton)
    }
    
    private func configureLayout() {
        chipButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        chipButton.setTitle(title: title)
    }
}
