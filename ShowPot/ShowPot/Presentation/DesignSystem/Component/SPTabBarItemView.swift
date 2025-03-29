//
//  SPTabBarItemView.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/21/24.
//

import UIKit
import SnapKit
import Then

class SPTabBarItem {
    let selectedIcon: UIImage
    let unselectedIcon: UIImage
    let title: String
    var isSelected: Bool
    
    init(selectedIcon: UIImage, unselectedIcon: UIImage? = nil, title: String, isSelected: Bool = false) {
        self.selectedIcon = selectedIcon
        self.unselectedIcon = unselectedIcon ?? selectedIcon
        self.title = title
        self.isSelected = isSelected
    }
}

protocol SPTabBarItemViewDelegate: AnyObject {
    func handleTap(_ view: SPTabBarItemView)
}

class SPTabBarItemView: UIView {
    
    // MARK: UI Component
    lazy var iconView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
    }
    
    lazy var titleLabel = SPLabel(KRFont.B1_semibold).then { label in
        label.textColor = .gray000
    }
    
    lazy var highlightView = UIView().then { view in
        view.layer.cornerRadius = 5
    }
    
    // MARK: Properties
    weak var delegate: SPTabBarItemViewDelegate?
    
    var isSelected: Bool = false {
        willSet {
            self.updateUI(isSelected: newValue)
        }
    }
    
    var item: SPTabBarItem? {
        didSet {
            if let item { self.configure(item: item) }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setUpView()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.addSubview(highlightView)
        highlightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [iconView, titleLabel].forEach { highlightView.addSubview($0) }
        iconView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(14)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalTo(iconView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(14)
        }
    }
}

extension SPTabBarItemView {
    private func configure(item: SPTabBarItem) {
        self.titleLabel.setText(item.title)
        self.iconView.image = item.isSelected ? item.selectedIcon : item.unselectedIcon
        self.isSelected = item.isSelected
    }
    
    private func updateUI(isSelected: Bool) {
        guard let item = self.item else { return }
        item.isSelected = isSelected
        
        let options: UIView.AnimationOptions = isSelected ? [.curveEaseIn] : [.curveEaseOut]
        UIView.animate(
            withDuration: 0.4, delay: 0.0, 
            usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5,
            options: options, animations: {
                self.titleLabel.text = isSelected ? item.title : nil
                self.iconView.image = isSelected ? item.selectedIcon : item.unselectedIcon
                self.highlightView.backgroundColor = isSelected ? .gray500 : .clear
                (self.superview as? UIStackView)?.layoutIfNeeded()
            }, 
            completion: nil
        )
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.handleTap(self)
    }
}
