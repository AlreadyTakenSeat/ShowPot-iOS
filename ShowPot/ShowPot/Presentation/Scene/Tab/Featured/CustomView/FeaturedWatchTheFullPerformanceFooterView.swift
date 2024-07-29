//
//  FeaturedWatchTheFullPerformanceFooterView.swift
//  ShowPot
//
//  Created by 이건준 on 7/26/24.
//

import UIKit

import RxCocoa
import SnapKit
import Then

final class FeaturedWatchTheFullPerformanceFooterView: UICollectionReusableView, ReusableCell {
    
    static let identifier = String(describing: FeaturedWatchTheFullPerformanceFooterView.self) // TODO: #46 identifier 지정코드로 변환
    
    var didTappedButton: ControlEvent<Void> {
        watchTheFullPerformanceButton.rx.tap
    }
    
    private let watchTheFullPerformanceButton = UIButton()
    
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
        var configuration = UIButton.Configuration.filled()
        configuration.imagePlacement = .trailing
        configuration.image = .icArrowRight.withTintColor(.gray400)
        configuration.attributedTitle = configureButtonAttributedString()
        configuration.baseBackgroundColor = .gray600
        configuration.baseForegroundColor = .gray100
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = 2
        watchTheFullPerformanceButton.configuration = configuration
    }
    
    private func setupLayouts() {
        addSubview(watchTheFullPerformanceButton)
    }
    
    private func setupConstraints() {
        watchTheFullPerformanceButton.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(42)
        }
    }
}

extension FeaturedWatchTheFullPerformanceFooterView {
    
    /// attributed가 적용된 라벨을 리턴하는 함수
    private func configureLabelAttributedText() -> UILabel { // TODO: #61 UIButton AttributedString에 대한 attribute적용 공통함수로 중복코드삭제
        let setAttributedButtonLabel = UILabel().then {
            $0.setAttributedText(font: KRFont.B1_semibold, string: Strings.homeTicketingPerformanceButtonTitle)
        }
        return setAttributedButtonLabel
    }
    
    /// UIButton.Configuration에 사용될 AttributedString을 리턴하는 함수
    private func configureButtonAttributedString() -> AttributedString? {
        let labelWithAttributedText = configureLabelAttributedText()
        guard let attributedText = labelWithAttributedText.attributedText else { return nil }
        
        var attributedString = AttributedString(attributedText)
        attributedString.font = KRFont.B1_semibold.font
        return attributedString
    }
}
