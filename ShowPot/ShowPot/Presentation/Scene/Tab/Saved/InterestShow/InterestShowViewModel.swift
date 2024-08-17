final class InterestShowViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
    }
}

// MARK: - For NSDiffableDataSource

extension InterestShowViewModel {
    
    typealias Item = ShowSummary
    typealias DataSource = UICollectionViewDiffableDataSource<InterestShowSection, Item>
    
    /// 관심 공연 섹션 타입
    enum InterestShowSection {
        case main
    }
    
    private func updateDataSource() {
        let currentShowList = showListRelay.value
        var snapshot = NSDiffableDataSourceSnapshot<InterestShowSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(currentShowList)
        dataSource?.apply(snapshot)
    }
}
