//
//  ShowDetailViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/11/24.
//

import UIKit

class ShowDetailViewController: ViewController {
    let viewHolder: ShowDetailViewHolder = .init()
    let viewModel: ShowDetailViewModel
    
    init(viewModel: ShowDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.useSafeArea = true
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
        
        self.setNavigationBarItem(title: Strings.showDetailTitle, leftIcon: .icArrowLeft.withTintColor(.gray000))
        self.contentNavigationBar.backgroundColor = .clear
    }
        
    override func bind() {
        
    }
}
