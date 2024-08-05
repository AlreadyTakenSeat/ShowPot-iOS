//
//  SubscribeArtistViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit

final class SubscribeArtistViewController: ViewController {
    let viewHolder: SubscribeArtistViewHolder = .init()
    let viewModel: SubscribeArtistViewModel
    
    init(viewModel: SubscribeArtistViewModel) {
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
        super.setupStyles()
        viewHolder.artistCollectionView.delegate = self
    }
    
    override func bind() {
extension SubscribeArtistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 100, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        (collectionView.frame.width - 27 * 2 - 100 * 3) / 2
    }
}

extension SubscribeArtistViewController {
    func makeDataSource() -> SubscribeArtistViewModel.DataSource {
        let cellRegistration = UICollectionView.CellRegistration<FeaturedSubscribeArtistCell, FeaturedSubscribeArtistCellModel> { (cell, indexPath, model) in
            cell.configureUI(with: model)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<SubscribeArtistViewModel.ArtistSection, FeaturedSubscribeArtistCellModel>(collectionView: viewHolder.artistCollectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
        return dataSource
    }
}
