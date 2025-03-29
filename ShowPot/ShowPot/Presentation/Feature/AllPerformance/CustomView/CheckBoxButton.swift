//
//  CheckBoxButton.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

import SnapKit
import Then

final class CheckBoxButton: SPButton {
    
    var isChecked: Bool = false {
        didSet {
            updateLayoutIfNeeded()
        }
    }
    
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        configuration?.image = .icCheckboxOff
        configuration?.imagePlacement = .leading
        configuration?.imagePadding = 9
        configuration?.contentInsets = .zero
        configuration?.baseBackgroundColor = .clear
        configuration?.baseForegroundColor = .gray100
        setText(title)
    }
}

extension CheckBoxButton {
    private func updateLayoutIfNeeded() {
        configuration?.image = isChecked ? .icCheckboxOn : .icCheckboxOff
    }
}
