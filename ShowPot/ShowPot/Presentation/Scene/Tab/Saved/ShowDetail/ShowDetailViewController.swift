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
        // TODO: #106 ViewHolder 개발 완료 후 ViewModel 사용하여 데이터 주입
        viewHolder.posterImageView.setImage(urlString: "https://enfntsterribles.com/wp-content/uploads/2023/08/enfntsterribles-nothing-but-thieves-01.jpg", option: .relativeHeight)
        viewHolder.titleView.titleLabel.setText("나씽 벗 띠브스 내한공연 (Nothing But Thieves Live in Seoul)")
        viewHolder.infoView.setData(date: "2024.08.21", location: "KBS 아레나홀")
    }
}
