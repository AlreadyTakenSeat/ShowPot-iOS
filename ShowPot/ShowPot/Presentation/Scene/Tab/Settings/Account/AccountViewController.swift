//
//  AccountViewController.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import UIKit

final class AccountViewController: ViewController {
    let viewHolder: AccountViewHolder = .init()
    let viewModel: AccountViewModel
    
    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
