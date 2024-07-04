//
//  OnboardingViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/4/24.
//

import UIKit

final class OnboardingViewController: ViewController {
    let viewHolder: OnboardingViewHolder = .init()
    let viewModel: OnboardingViewModel
    
    init(viewModel: ViewModel) {
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
        self.view.backgroundColor = .mainOrange
    }
    
    override func bind() {
        
    }
}
