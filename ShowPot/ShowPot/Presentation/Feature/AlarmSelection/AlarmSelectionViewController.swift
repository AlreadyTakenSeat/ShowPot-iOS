//
//  AlarmSelectionViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//

import UIKit

import SnapKit
import RxCompose
import RxSwift
import RxCocoa

final class AlarmSelectionViewController: UIViewController, Composable {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )
    private let bottomButton = SPCTABottomButton(title: "알림 설정하기", style: .plain)
    
    private var dataSource: DataSource?
    
    @Compose
    var composer: AlarmSelectionViewModel
    var disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(composer: AlarmSelectionViewModel) {
        self.composer = composer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        configureDataSource()
        
        sheetPresentationController?.detents = [
            .custom { _ in return 460 }
        ]
        sheetPresentationController?.preferredCornerRadius = 0
        sheetPresentationController?.prefersGrabberVisible = true
        
        bindState()
        
        bindAction()
    }
}

// MARK: - Configure View
private extension AlarmSelectionViewController {
    private func configureUI() {
        view.backgroundColor = .gray600
        
        configureTitleLabel()
        configureCollectionView()
        configureBottomButton()
    }
    
    private func configureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(bottomButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top).offset(-16) // 여백 추가
        }
        
        bottomButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.attributedText = NSAttributedString(
            "티켓팅 알림을 언제 받으실건가요?",
            fontType: KRFont.H1
        )
        .setForegroundColor(color: .gray100)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false // 항목이 적으므로 스크롤 불필요
    }
    
    private func configureBottomButton() {
        bottomButton.ctaButton.isEnabled = !composer.state.selectedTime.isEmpty
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, environment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            configuration.backgroundColor = .clear
            
            let section = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: environment
            )
            section.contentInsets = .init(top: 0, leading: 16, bottom: 20, trailing: 16)
            section.interGroupSpacing = 12
            return section
        }
    }
}

// MARK: - DataSource and Snapshot
private extension AlarmSelectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Registration = UICollectionView.CellRegistration<AlarmCell, AlertTime>
    
    enum Section: Int, CaseIterable {
        case alertTimes
    }
    
    enum Item: Hashable {
        case alertTime(AlertTime, Bool, Bool)
    }
    
    func configureDataSource() {
        let cellRegistration = Registration { _, _, _ in }
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch item {
            case let .alertTime(time, isSelected, isPassed):
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: time
                )
                cell.configure(
                    with: time,
                    isSelected: isSelected,
                    isPassed: isPassed
                )
                return cell
            }
        }
    }
    
    func applySnapshot(
        times: [AlertTime],
        selectedTime: Set<AlertTime>,
        ticketingTimes: [ShowDetailEntity.TicketingTime]
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(
            times.map { time in
                let isPassed = ticketingTimes.contains(where: {
                    let date = $0.ticketingAt.toDate(.default) ?? .now
                    let alarmDate = date.addMinutes(
                        minutes: -Double(time.minutes)
                    )
                    return Date.now >= alarmDate
                })
                return .alertTime(time, selectedTime.contains(time), isPassed)
            },
            toSection: .alertTimes
        )
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Binding
private extension AlarmSelectionViewController {
    func bindAction() {
        // 셀 선택 이벤트 처리
        collectionView.rx.itemSelected
            .map { Action.itemSelected($0.item) }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        bottomButton.ctaButton.rx.tap
            .map { Action.bottomButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        Driver.combineLatest(
            composer.$state.observable.map(\.alarms),
            composer.$state.observable.map(\.selectedTime),
            composer.$state.observable.map(\.ticketingTimes)
        )
        .drive(with: self) { this, value in
            let (times, selectedTime, ticketingTimes) = value
            this.applySnapshot(
                times: times,
                selectedTime: selectedTime,
                ticketingTimes: ticketingTimes
            )
            this.bottomButton.ctaButton.isEnabled = !selectedTime.isEmpty
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Helper Enum
enum AlertTime: Int, CaseIterable {
    case fiveMinutes = 0
    case tenMinutes = 1
    case thirtyMinutes = 2
    case oneHour = 3
    
    var minutes: Int {
        switch self {
        case .fiveMinutes: return 5
        case .tenMinutes: return 10
        case .thirtyMinutes: return 30
        case .oneHour: return 60
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    AlarmSelectionViewController(composer: AlarmSelectionViewModel(ticketingTimes: ShowDetailEntity.mock.ticketingTimes))
}
