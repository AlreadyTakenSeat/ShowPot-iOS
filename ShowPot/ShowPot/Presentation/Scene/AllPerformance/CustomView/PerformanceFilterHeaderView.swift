//
//  PerformanceFilterHeaderView.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

import iOSDropDown
import RxSwift
import SnapKit
import Then

protocol PerformanceFilterHeaderViewDelegate: AnyObject {
    func selectedDropdown(text: String)
}

final class PerformanceFilterHeaderView: UICollectionReusableView, ReusableCell {
    
    weak var delegate: PerformanceFilterHeaderViewDelegate?
    
    var didTappedCheckBox: Observable<Bool> {
        checkBoxButton.rx.tap
            .withUnretained(self)
            .map { !$0.0.checkBoxButton.isChecked }
            .asObservable()
            .share(replay: 1)
    }
    
    private let disposeBag = DisposeBag()
    private let checkBoxButton = CheckBoxButton(title: Strings.allPerformanceCheckboxTitle)
    private lazy var dropdown = DropDown(frame: .init(x: .zero, y: .zero, width: .zero, height: 25)).then {
        $0.backgroundColor = .gray500
        $0.rowBackgroundColor = .gray500
        $0.textColor = .gray400
        $0.font = KRFont.B1_semibold.font
        $0.itemsColor = .gray000
        $0.arrowColor = .gray200
        $0.textAlignment = .center
        $0.isSearchEnable = false
        $0.checkMarkEnabled = false
        $0.arrowSize = 12
        $0.selectedRowColor = .gray500
        $0.rowHeight = 40
        $0.cornerRadius = 2
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
        [checkBoxButton, dropdown].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        checkBoxButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.directionalVerticalEdges.equalToSuperview().inset(8)
        }
        
        dropdown.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(83)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        
        dropdown.didSelect { [weak self] (selectedText, index, id) in
            guard let self = self,
                  let text = self.dropdown.text else { return }
            
            self.dropdown.optionArray.removeAll(where: { $0 == selectedText })
            self.dropdown.optionArray.append(text)
            self.delegate?.selectedDropdown(text: selectedText)
        }
        
        didTappedCheckBox
            .subscribe(checkBoxButton.rx.isChecked)
            .disposed(by: disposeBag)
    }
}

extension PerformanceFilterHeaderView {
    func configureUI(
        dropdownOptions: [String],
        defaultSelectedOption: String
    ) {
        configureDropdown(options: dropdownOptions, defaultOption: defaultSelectedOption)
    }
    
    private func configureDropdown(options: [String], defaultOption: String) {
        dropdown.optionArray = options
        if let defaultIndex = options.firstIndex(of: defaultOption) {
            dropdown.selectedIndex = defaultIndex
        }
        dropdown.text = defaultOption
    }
}
