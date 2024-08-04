//
//  SubscribeArtistViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/5/24.
//

import Foundation

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
    
    override func bind() {
        
    }
}
