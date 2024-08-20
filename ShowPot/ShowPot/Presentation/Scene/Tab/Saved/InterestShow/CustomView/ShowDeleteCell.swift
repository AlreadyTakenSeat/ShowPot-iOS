//
//  ShowDeleteCell.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import UIKit

import RxGesture
import RxSwift

protocol ShowDeleteCellDelegate: AnyObject {
    func didTappedDeleteButton(_ cell: UICollectionViewCell)
}

final class ShowDeleteCell: PerformanceInfoCollectionViewCell {
    private var disposeBag = DisposeBag()
    weak var delegate: ShowDeleteCellDelegate?

    private let deleteButton = ShowDeleteButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupLayouts() {
        contentView.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(3)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(34)
            $0.width.equalTo(63)
        }
        
        performanceTimeLabel.snp.remakeConstraints {
            $0.leading.equalTo(performanceTitleLabel)
            $0.trailing.lessThanOrEqualTo(deleteButton.snp.leading)
            $0.top.equalTo(performanceTitleLabel.snp.bottom).offset(5)
            $0.height.equalTo(18)
        }
        
        performanceLocationLabel.snp.remakeConstraints {
            $0.leading.equalTo(performanceTimeLabel)
            $0.trailing.lessThanOrEqualTo(deleteButton.snp.leading)
            $0.top.equalTo(performanceTimeLabel.snp.bottom).offset(1)
            $0.bottom.equalToSuperview().inset(2)
            $0.height.equalTo(18)
        }
    }
    
    private func bind() {
        deleteButton.rx.tapGesture().when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.delegate?.didTappedDeleteButton(owner)
            }
            .disposed(by: disposeBag)
    }
}
