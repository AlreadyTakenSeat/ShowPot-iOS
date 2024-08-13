//
//  SavedViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import UIKit

import RxSwift

final class SavedViewController: ViewController {
    let viewHolder: SavedViewHolder = .init()
    let viewModel: SavedViewModel
    
    init(viewModel: SavedViewModel) {
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
        viewHolder.menuCollectionView.delegate = self
        viewHolder.upcomingCarouselView.delegate = self
    }
    
    override func bind() {
        
extension SavedViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == viewHolder.menuCollectionView {
            return .init(width: collectionView.frame.width, height: 44)
        } else if collectionView == viewHolder.upcomingCarouselView {
            return .init(width: collectionView.frame.width - 66 * 2, height: 357)
        }
        return .zero
    }
    }
}
