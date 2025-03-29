//
//  WebContentViewHolder.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit
import WebKit
import SnapKit

final class WebContentViewHolder {
    let webView = WKWebView()
}

extension WebContentViewHolder: ViewHolderType {
    
    func place(in view: UIView) {
        view.addSubview(webView)
    }
    
    func configureConstraints(for view: UIView) {
        webView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

