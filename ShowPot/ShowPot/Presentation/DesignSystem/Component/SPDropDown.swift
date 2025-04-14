//
//  SPDropDown.swift
//  ShowPot
//
//  Created by 김도형 on 3/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - 옵션 아이템 모델
struct DropdownOption: Hashable {
    let id = UUID()
    let title: String
}

// MARK: - 드롭다운 버튼 클래스
final class SPDropdownButton: UIView {
    // MARK: - 열거형 및 타입 정의
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DropdownOption>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DropdownOption>
    
    enum Section {
        case main
    }
    
    // MARK: - 프로퍼티
    private let containerView = UIView()
    private let button = UIButton(type: .custom)
    private let arrowImageView = UIImageView()
    private lazy var optionsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private let separatorView = UIView()
    
    private var isDropdownVisible = false {
        didSet { didSetIsDropdownVisible() }
    }
    private let style: Style
    private var options: [DropdownOption]
    private var selectedOption = 0
    private var dataSource: DataSource!
    private let disposeBag = DisposeBag()
    
    // Rx 관련 프로퍼티
    private let _selectedOption = PublishRelay<String>()
    var selectedOptionObservable: Observable<String> {
        return _selectedOption.asObservable()
    }
    
    // MARK: - 초기화
    init(options: [String], style: Style = .plain) {
        self.options = options.map { DropdownOption(title: $0) }
        self.style = style
        super.init(frame: .zero)
        
        configureUI()
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 선택된 옵션 반환
    func getSelectedOption() -> String {
        return options[selectedOption].title
    }
    
    // 옵션 설정
    func setOptions(_ newOptions: [String]) {
        options = newOptions.map { DropdownOption(title: $0) }
        let nsStr = NSAttributedString(
            options[selectedOption].title,
            fontType: KRFont.H2
        )
        button.configuration?.attributedTitle = AttributedString(nsStr)
        applySnapshot()
    }
    
    private func didSetIsDropdownVisible() {
        let buttonColor: UIColor = isDropdownVisible ? .gray400 : .gray000
        button.configuration?.baseForegroundColor = buttonColor
        if style == .showList {
            containerView.backgroundColor = isDropdownVisible ? .gray500 : .gray700
        }
        
        if isDropdownVisible {
            containerView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
        } else {
            containerView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
            ]
        }
        
        // optionsCollectionView 표시/숨김 처리 개선
        optionsCollectionView.isHidden = false
        optionsCollectionView.isUserInteractionEnabled = true
        separatorView.isHidden = false
        
        separatorView.snp.updateConstraints { make in
            make.height.equalTo(isDropdownVisible ? 1 : 0)
        }
        optionsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(isDropdownVisible ? ((options.count - 1) * 40) : 0)
        }
        
        // 레이아웃 강제 업데이트
        layoutIfNeeded()
        
        UIView.springAnimate { [weak self] in
            guard let self else { return }
            separatorView.alpha = isDropdownVisible ? 1 : 0
            optionsCollectionView.alpha = isDropdownVisible ? 1 : 0
        } completion: { [weak self] completed in
            guard let self else { return }
            if !isDropdownVisible {
                optionsCollectionView.isHidden = true
                optionsCollectionView.isUserInteractionEnabled = false
                separatorView.isHidden = true
            }
        }
        
        // 디버깅: 터치 가능 여부 확인
        print("Dropdown visible: \(isDropdownVisible), optionsCollectionView frame: \(optionsCollectionView.frame)")
    }
    
    // MARK: - 액션
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        
        // 화살표 회전
        UIView.springAnimate { [weak self] in
            guard let self else { return }
            arrowImageView.transform = isDropdownVisible
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity
        }
    }
}

// MARK: - Configure View
private extension SPDropdownButton {
    func configureUI() {
        configureContainerView()
        configureSeparatorView()
        configureButton()
        configureArrowImageView()
        configureCollectionView()
    }
    
    func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-4)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.size.equalTo(24)
        }
        
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(containerView)
            make.height.equalTo(0)
            make.top.equalTo(containerView.snp.bottom)
        }
        
        optionsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.horizontalEdges.equalTo(containerView)
            make.height.equalTo(0) // 보여줄 때 업데이트됨
        }
    }
    
    func configureContainerView() {
        let color: UIColor = style == .showList ? .gray700 : .gray500
        containerView.backgroundColor = color
        containerView.layer.cornerRadius = 2
        addSubview(containerView)
    }
    
    func configureButton() {
        var configuration = UIButton.Configuration.plain()
        let nsStr = NSAttributedString(
            options[selectedOption].title,
            fontType: KRFont.H2
        )
        configuration.attributedTitle = AttributedString(nsStr)
        configuration.baseForegroundColor = .gray000
        configuration.contentInsets = .zero
        button.configuration = configuration
        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        containerView.addSubview(button)
    }
    
    func configureArrowImageView() {
        let arrowImage: UIImage = .icArrowDown
            .withRenderingMode(.alwaysTemplate)
        arrowImageView.image = arrowImage
        arrowImageView.tintColor = .gray200
        arrowImageView.contentMode = .scaleAspectFit
        containerView.addSubview(arrowImageView)
    }
    
    func configureCollectionView() {
        // 컬렉션 뷰 기본 설정
        optionsCollectionView.layer.cornerRadius = 2
        optionsCollectionView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        optionsCollectionView.backgroundColor = .gray500
        optionsCollectionView.isScrollEnabled = false
        optionsCollectionView.isHidden = true
        optionsCollectionView.isUserInteractionEnabled = true // 터치 활성화 보장
        addSubview(optionsCollectionView)
        
        // 셀 등록
        optionsCollectionView.register(
            DropdownOptionCell.self,
            forCellWithReuseIdentifier: DropdownOptionCell.reuseIdentifier
        )
        
        // DiffableDataSource 설정
        setupDataSource()
        
        // 초기 스냅샷 적용
        applySnapshot()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureSeparatorView() {
        separatorView.backgroundColor = .gray400
        separatorView.isHidden = true
        addSubview(separatorView)
    }
    
    func setupDataSource() {
        // DataSource 설정
        dataSource = DataSource(
            collectionView: optionsCollectionView
        ) { collectionView, indexPath, option in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DropdownOptionCell.reuseIdentifier,
                for: indexPath
            ) as? DropdownOptionCell
            cell?.configure(with: option.title)
            return cell
        }
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let selectedOption = options[selectedOption]
        snapshot.appendItems(options.filter { $0.id != selectedOption.id })
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func bind() {
        // 컬렉션 뷰 아이템 선택 처리
        optionsCollectionView.rx.itemSelected
            .bind(with: self) { this, indexPath in
                print("Item selected at indexPath: \(indexPath)") // 디버깅 로그 추가
                let item = this.dataSource.itemIdentifier(for: indexPath)
                let index = this.options.firstIndex(where: { $0.id == item?.id })
                guard let index else { return }
                
                this.selectedOption = index
                let title = this.options[this.selectedOption].title
                
                let nsStr = NSAttributedString(title, fontType: KRFont.H2)
                this.button.configuration?.attributedTitle = AttributedString(nsStr)
                
                this._selectedOption.accept(title)
                this.toggleDropdown()
                this.applySnapshot()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Style
extension SPDropdownButton {
    enum Style {
        case plain
        case showList
    }
}

// MARK: - DropdownOptionCell
final class DropdownOptionCell: UICollectionViewCell {
    static let reuseIdentifier = "DropdownOptionCell"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    override var isHighlighted: Bool {
        didSet {
            let color: UIColor = isHighlighted ? .gray400 : .gray500
            contentView.backgroundColor = color
        }
    }
    
    private func configureUI() {
        contentView.backgroundColor = .gray500
        
        titleLabel.textColor = .gray000
        titleLabel.font = KRFont.H2.font
        contentView.addSubview(titleLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SPDropdownButton(options: ["A-Z", "Z-A"], style: .plain)
}
