//
//  FeaturedSearchViewController.swift
//  ShowPot
//
//  Created by 이건준 on 7/22/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class FeaturedSearchViewController: ViewController {
    let viewHolder: FeaturedSearchViewHolder = .init()
    let viewModel: FeaturedSearchViewModel
    init(viewModel: FeaturedSearchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolderConfigure()
    }
    
    override func setupStyles() {
        view.backgroundColor = .gray700
        viewHolder.recentSearchCollectionView.delegate = self
        viewHolder.searchQueryResultCollectionView.delegate = self
        viewHolder.featuredSearchTextField.searchTextFieldDelegate = self
// MARK: - UICollectionViewDelegateFlowLayout

extension FeaturedSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == viewHolder.recentSearchCollectionView {
            let label = UILabel().then {
                $0.font = KRFont.B1_regular
                $0.setAttributedText(font: KRFont.self, string: viewModel.recentSearchQueryList[indexPath.row])
                $0.sizeToFit()
            }
            let size = label.frame.size
            let maxWidth = UIScreen.main.bounds.width - 32
            let additionalWidth: CGFloat = 24 + 14 + 8
            let width = min(maxWidth, additionalWidth + size.width)
            return CGSize(width: width, height: 40)
        }
        return CGSize(width: collectionView.frame.width - 32, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == viewHolder.recentSearchCollectionView {
            return .init(width: collectionView.frame.width, height: 44)
        }
        return .zero
    }
}
    }
