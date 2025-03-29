//
//  ShowDetailLabelStackView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/14/24.
//

import UIKit
import SnapKit
import Then

final class ShowDetailLabelStackView: UIStackView {
    
    lazy var titleLabel = SPLabel(KRFont.B1_regular).then { label in
        label.textColor = .gray300
        label.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    lazy var descriptionLabel = SPLabel(KRFont.B1_regular).then { label in
        label.textColor = .gray200
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    convenience init(title: String, description: String? = nil) {
        self.init()
        
        self.titleLabel.setText(title)
        if let description { self.descriptionLabel.setText(description) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .leading
        self.spacing = 10
        
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(descriptionLabel)
    }
}

extension ShowDetailLabelStackView {
    
    func setData(title: String, description: String) {
        self.titleLabel.setText(title)
        self.descriptionLabel.setText(description)
    }
    
    func setData(description: String) {
        self.descriptionLabel.setText(description)
    }
}
