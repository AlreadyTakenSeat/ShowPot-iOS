//
//  GenreChipCell.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GenreChipCell: UICollectionViewCell {
    private let chip = SPChip(title: "", style: .default)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(chip)
    }
    
    private func configureLayout() {
        chip.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with genreName: String) {
        chip.setTitle(title: genreName)
    }
}