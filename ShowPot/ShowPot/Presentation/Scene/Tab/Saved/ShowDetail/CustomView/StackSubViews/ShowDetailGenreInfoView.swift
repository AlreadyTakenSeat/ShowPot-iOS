//
//  ShowDetailGenreInfoView.swift.swift
//  ShowPot
//
//  Created by 이건준 on 8/22/24.
//

import UIKit

import SnapKit
import Then

final class ShowDetailGenreInfoView: UIView {
    private let titleLabel = SPLabel(KRFont.H2).then { label in
        label.textColor = .gray000
        label.setText(Strings.showGenre)
    }
    
    private let showGenreListViewLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 8
        $0.sectionInset = .init(top: 12, left: 16, bottom: 37, right: 16)
        $0.scrollDirection = .vertical
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    lazy var showGenreListView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: showGenreListViewLayout).then {
        $0.register(ShowGenreCell.self)
        $0.backgroundColor = .gray700
        $0.isScrollEnabled = false
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
        [titleLabel, showGenreListView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        showGenreListView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}

final class ShowGenreCell: UICollectionViewCell, ReusableCell {

    private let genreLabel = SPLabel(KRFont.B1_regular, alignment: .center).then {
        $0.textColor = .gray000
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        contentView.backgroundColor = .gray700
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 18
        contentView.layer.borderColor = UIColor.gray400.cgColor
        contentView.layer.borderWidth = 1
    }
    
    private func setupLayouts() {
        [genreLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        genreLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(14)
            $0.directionalVerticalEdges.equalToSuperview().inset(8)
        }
    }
}

extension ShowGenreCell {
    func configureUI(with genre: String) {
        genreLabel.setText(genre)
    }
}
