//
//  SubscribeArtistViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import UIKit
import SnapKit

final class SubscribeArtistViewHolder {
    
    private var statusBarHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        return windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    let topView = SubscribeArtistTopView()
    
    private let artistCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = .init(top: 18, left: 27, bottom: .zero, right: 27)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 20
    }
    
    lazy var artistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: artistCollectionViewLayout).then {
        $0.register(FeaturedSubscribeArtistCell.self)
        $0.backgroundColor = .gray700
        $0.alwaysBounceVertical = true
    }
    
    lazy var subscribeButton = SubscribeButton(
        frame: .init(
            x: .zero,
            y: UIScreen.main.bounds.height - statusBarHeight,
            width: UIScreen.main.bounds.width,
            height: 113
        )
    )
}

extension SubscribeArtistViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        [topView, artistCollectionView, subscribeButton].forEach { view.addSubview($0) }
    }
    
    func configureConstraints(for view: UIView) {
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(102)
        }
        
        artistCollectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
}

extension SubscribeArtistViewHolder {
    
    func showButton() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.25,
            options: .curveEaseIn) {
                self.subscribeButton.frame.origin.y -= 113
            }
    }
    
    func dismissButton() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.25,
            options: .curveEaseOut) {
                self.subscribeButton.frame.origin.y += 113
            }
    }
}
