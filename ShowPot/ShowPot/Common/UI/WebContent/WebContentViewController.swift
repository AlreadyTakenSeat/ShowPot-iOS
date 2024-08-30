//
//  WebContentViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit

import RxSwift

final class WebContentViewController: ViewController {
    
    let viewHolder: WebContentViewHolder = .init()
    let viewModel: WebContentViewModel
    
    init(viewModel: WebContentViewModel) {
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
        setNavigationBarItem(
            title: "",
            leftIcon: .icArrowLeft.withTintColor(.gray000)
        )
    }
    
    override func bind() {
        super.bind()
        let input = WebContentViewModel.Input(didTappedBackButton: contentNavigationBar.didTapLeftButton.asObservable())
        let output = viewModel.transform(input: input)
        output.webURL
            .subscribe(with: self) { owner, url in
                let request = URLRequest(url: url)
                owner.viewHolder.webView.load(request)
            }
            .disposed(by: disposeBag)
    }
}

