//
//  DeleteArtistCell.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

protocol DeleteArtistCellDelegate: AnyObject {
    func didTappedDeleteButton(_ cell: UICollectionViewCell)
}

final class DeleteArtistCell: FeaturedSubscribeArtistCell {
    
    private let disposeBag = DisposeBag()
    weak var delegate: DeleteArtistCellDelegate?
    
    private let deleteButton = SPButton().then {
        $0.configuration?.image = .icXmarkCircle
        $0.configuration?.baseBackgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        contentView.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        deleteButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    private func bind() {
        deleteButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.delegate?.didTappedDeleteButton(owner)
            }
            .disposed(by: disposeBag)
    }
}
