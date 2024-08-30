//
//  MyArtistViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/30/24.
//

import Foundation

final class MyArtistViewController: ViewController {
    let viewHolder: MyArtistViewHolder = .init()
    let viewModel: MyArtistViewModel
    
    init(viewModel: MyArtistViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
