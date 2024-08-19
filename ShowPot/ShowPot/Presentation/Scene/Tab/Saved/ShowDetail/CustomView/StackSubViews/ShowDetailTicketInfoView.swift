//
//  ShowDetailTicketInfoView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/15/24.
//

import UIKit
import SnapKit
import Then

final class ShowDetailTicketInfoView: UIView {
    
    // MARK: Title
    lazy var titleLabel = SPLabel(KRFont.H2).then { label in
        label.textColor = .gray000
        label.setText(Strings.showTicketopenInfo)
    }
    
    // MARK: CollectionView
    private let ticketSaleLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 8
        $0.sectionInset = .init(top: .zero, left: 15, bottom: .zero, right: 15)
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    lazy var ticketSaleCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ticketSaleLayout
    ).then { collectionView in
        collectionView.register(TicketSaleCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
    }
    
    // MARK: Labels
    lazy var subInfoStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.spacing = 4
    }
    
    lazy var preTicketSaleView = ShowDetailLabelStackView(title: Strings.showPreTicketopen)
    lazy var normalTicketSaleView = ShowDetailLabelStackView(title: Strings.showNormalTicketopen)
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
        self.setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        [titleLabel, ticketSaleCollectionView, subInfoStackView].forEach { self.addSubview($0) }
        [preTicketSaleView, normalTicketSaleView].forEach { subInfoStackView.addArrangedSubview($0)}
    }
    
    private func setUpLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        ticketSaleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(30) // TODO: #135 Self-sizing Cell 구현
        }
        
        subInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(ticketSaleCollectionView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(14)
        }
        
    }
    
    func setDateData(pre: String, normal: String) {
        self.preTicketSaleView.setData(description: pre)
        self.normalTicketSaleView.setData(description: normal)
    }
}

final class TicketSaleCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    lazy var titleLabel = SPLabel(KRFont.B1_regular).then { label in
        label.textColor = .gray000
    }
    
    lazy var iconImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.image = .icArrowRight.withTintColor(.gray000)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpLayout() {
        
        [titleLabel, iconImageView].forEach { contentView.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(9)
        }
        
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.leading.equalTo(titleLabel.snp.trailing).inset(1)
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    func setData(title: String, color: UIColor) {
        self.titleLabel.setText(title)
        self.backgroundColor = color
    }
}
