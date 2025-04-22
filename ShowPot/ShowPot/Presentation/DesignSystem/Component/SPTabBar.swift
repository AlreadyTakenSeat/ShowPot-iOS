//
//  SPTabBar.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// 탭 아이템 구조체
struct TabItem {
    let normalImage: UIImage
    let selectedImage: UIImage
    let title: String
}

// 커스텀 탭바 클래스
final class SPTabBar: UIView {
    private let stackView = UIStackView()
    private let selectionIndicator = UIView()
    private var tabButtons: [UIButton] = []
    private let disposeBag = DisposeBag()
    public let selectedIndex = BehaviorSubject<Int>(value: 0)
    
    // 선택 인디케이터 여백 설정 (컨텐츠 주변 기본 여백)
    private let indicatorInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)

    init(tabItems: [TabItem]) {
        super.init(frame: .zero)
        configureUI(tabItems: tabItems)
        
        configureLayout()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        let tapObservables = tabButtons.enumerated().map { index, button in
            button.rx.tap.map { index }
        }
        Observable.merge(tapObservables)
            .bind(with: self) { this, index in
                this.selectedIndex.onNext(index)
                // 버튼 탭 시 레이아웃과 인디케이터를 애니메이션으로 업데이트
                this.animateLayoutAndIndicator(to: index)
            }
            .disposed(by: disposeBag)
        
        for (index, button) in tabButtons.enumerated() {
            selectedIndex.map { $0 == index }
                .bind(to: button.rx.isSelected)
                .disposed(by: disposeBag)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 레이아웃이 완료된 후 인디케이터 위치 업데이트
        updateSelectionIndicatorPosition()
    }
}


// MARK: - Configure Views
private extension SPTabBar {
    func configureUI(tabItems: [TabItem]) {
        backgroundColor = .gray800
        
        configureSelectionIndicator()
        
        configureStackView()
        
        configureTabButtons(tabItems)
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(28)
        }
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        addSubview(stackView)
    }
    
    func configureSelectionIndicator() {
        selectionIndicator.backgroundColor = .darkGray
        selectionIndicator.layer.cornerRadius = 5
        addSubview(selectionIndicator)
    }
    
    func configureTabButtons(_ tabItems: [TabItem]) {
        for tabItem in tabItems {
            // UIButton.Configuration 설정
            var config = UIButton.Configuration.plain()
            
            // 기본 상태 (비선택)
            config.image = tabItem.normalImage
                .resized(to: CGSize(width: 24, height: 24))
                .withRenderingMode(.alwaysOriginal)
            
            config.imagePlacement = .leading // 이미지 배치를 leading으로 변경
            config.imagePadding = 6 // 이미지와 텍스트 간격
            config.baseBackgroundColor = .clear
            config.contentInsets = .zero
            config.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 28,
                bottom: 8,
                trailing: 28
            )
            
            // 선택 상태
            var selectedConfig = config
            selectedConfig.image = tabItem.selectedImage.withRenderingMode(.alwaysOriginal)
            let nsStr = NSAttributedString(
                tabItem.title,
                fontType: KRFont.B1_semibold
            ).setForegroundColor(color: .gray000)
            selectedConfig.attributedTitle = AttributedString(nsStr)
            selectedConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = .white
                return outgoing
            }
            
            // 버튼 생성
            let button = UIButton(configuration: config, primaryAction: nil)
            button.configurationUpdateHandler = { btn in
                btn.configuration = btn.isSelected ? selectedConfig : config
            }
            
            stackView.addArrangedSubview(button)
            tabButtons.append(button)
        }
    }
    
    // 선택 인디케이터 위치 업데이트 (애니메이션 없이)
    private func updateSelectionIndicatorPosition() {
        guard let index = try? selectedIndex.value(), index < tabButtons.count else { return }
        let selectedButton = tabButtons[index]
        
        // 버튼 프레임을 stackView의 좌표계에서 SPTabBar의 좌표계로 변환
        let buttonFrameInTabBar = convert(selectedButton.frame, from: stackView)
        
        // 컨텐츠 크기 계산
        let contentSize = calculateContentSize(for: selectedButton)
        
        // 인디케이터 크기 계산
        // 가로 크기는 컨텐츠 크기에 맞춤 (여백 추가)
        let indicatorWidth = contentSize.width + indicatorInset.left + indicatorInset.right
        // 높이는 컨텐츠 크기에 맞춤
        let indicatorHeight = contentSize.height + indicatorInset.top + indicatorInset.bottom
        
        // 인디케이터를 버튼 중앙에 배치
        let indicatorX = buttonFrameInTabBar.origin.x + (buttonFrameInTabBar.width - indicatorWidth) / 2
        let indicatorY = buttonFrameInTabBar.origin.y + (buttonFrameInTabBar.height - indicatorHeight) / 2
        
        let indicatorFrame = CGRect(
            x: indicatorX,
            y: indicatorY,
            width: indicatorWidth,
            height: indicatorHeight
        )
        
        selectionIndicator.frame = indicatorFrame
    }
    
    // 컨텐츠 크기 계산 메서드 (선택/비선택 상태에 관계없이 동일한 크기 반환)
    private func calculateContentSize(for button: UIButton) -> CGSize {
        guard let config = button.configuration else { return .zero }
        
        // 기본 상태의 이미지 크기
        let normalImageSize = config.image?.size ?? .zero
        
        // 선택 상태의 이미지와 제목 크기를 가져오기 위해 임시로 상태 변경
        let originalIsSelected = button.isSelected
        button.isSelected = true
        button.configurationUpdateHandler?(button)
        let selectedImageSize = button.configuration?.image?.size ?? normalImageSize
        let title = button.configuration?.title
        button.isSelected = originalIsSelected
        button.configurationUpdateHandler?(button)
        
        // 제목 크기
        let titleSize: CGSize
        if let title = title {
            let attributes = [NSAttributedString.Key.font: KRFont.B1_semibold.font]
            titleSize = (title as NSString).size(withAttributes: attributes)
        } else {
            titleSize = .zero
        }
        
        // 컨텐츠 크기 계산 (imagePlacement가 .leading이므로 가로로 배치됨)
        // 가로 크기: 이미지 너비 + 간격 + 제목 너비
        let contentWidth = max(normalImageSize.width, selectedImageSize.width) + (titleSize.width > 0 ? config.imagePadding + titleSize.width : 0)
        // 세로 크기: 이미지와 제목 중 더 큰 높이
        let contentHeight = max(max(normalImageSize.height, selectedImageSize.height), titleSize.height)
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // 레이아웃과 인디케이터를 함께 애니메이션
    private func animateLayoutAndIndicator(to index: Int) {
        guard index < tabButtons.count else { return }
        let selectedButton = tabButtons[index]
        
        // 버튼 프레임을 stackView의 좌표계에서 SPTabBar의 좌표계로 변환
        let buttonFrameInTabBar = convert(selectedButton.frame, from: stackView)
        
        // 컨텐츠 크기 계산
        let contentSize = calculateContentSize(for: selectedButton)
        
        // 인디케이터 크기 계산
        // 가로 크기는 컨텐츠 크기에 맞춤 (여백 추가)
        let indicatorWidth = contentSize.width + indicatorInset.left + indicatorInset.right
        // 높이는 컨텐츠 크기에 맞춤
        let indicatorHeight = contentSize.height + indicatorInset.top + indicatorInset.bottom
        
        // 인디케이터를 버튼 중앙에 배치
        let indicatorX = buttonFrameInTabBar.origin.x + (buttonFrameInTabBar.width - indicatorWidth) / 2
        let indicatorY = buttonFrameInTabBar.origin.y + (buttonFrameInTabBar.height - indicatorHeight) / 2
        
        let newFrame = CGRect(
            x: indicatorX,
            y: indicatorY,
            width: indicatorWidth,
            height: indicatorHeight
        )
        
        // 레이아웃과 인디케이터를 함께 애니메이션
        UIView.springAnimate {
            // stackView 레이아웃 업데이트 (버튼 크기 변경 애니메이션)
            self.stackView.layoutIfNeeded()
            // 선택 인디케이터 이동 애니메이션
            self.selectionIndicator.frame = newFrame
        }
    }
}


@available(iOS 17.0, *)
#Preview {
    let tabBar = SPTabBar(tabItems: [
        TabItem(
            normalImage: .icHome,
            selectedImage: .icHomeFilled,
            title: "홈"
        ),
        TabItem(
            normalImage: .icShow,
            selectedImage: .icShowFilled,
            title: "내 공연"
        ),
        TabItem(
            normalImage: .icMy,
            selectedImage: .icMyFilled,
            title: "마이"
        )
    ])
    
    tabBar.snp.makeConstraints { make in
        make.height.equalTo(80)
        make.width.equalTo(393)
    }
    
    return tabBar
}
