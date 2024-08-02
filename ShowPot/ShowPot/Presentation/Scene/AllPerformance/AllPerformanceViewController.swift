//
//  AllPerformanceViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/2/24.
//

import UIKit

final class AllPerformanceViewController: ViewController {
    let viewHolder: AllPerformanceViewHolder = .init()
    let viewModel: AllPerformanceViewModel
    
    init(viewModel: AllPerformanceViewModel) {
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
