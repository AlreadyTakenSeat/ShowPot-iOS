//
//  BaseViewController.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

import Foundation
import UIKit
import class RxSwift.DisposeBag

protocol BaseViewControllerPorotocol where Self: BaseViewController {
    associatedtype ViewHolder: ViewHolderType
    associatedtype ViewModel: ViewModelType
    
    var viewHolder: ViewHolder { get }
    var viewModel: ViewModel { get }
}

extension BaseViewControllerPorotocol {
    func viewHolderConfigure() {
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
}

typealias ViewController = BaseViewController & BaseViewControllerPorotocol

class BaseViewController: UIViewController {
    
    var contentNavigationBar = SPNavigationBarView("")
    var contentView = UIView()
    
    var showNavigaitonBar: Bool = false
    final let disposeBag = DisposeBag()
    
    deinit {
        LogHelper.debug("called \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogHelper.debug("called \(self)")
        setupStyles()
        setUpContentView()
        setUpContentLayout()
        bind()
    }
    
    // 빈 영역 터치시 키보드 dismiss를 위한 코드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// 현재 ViewController의 view 관련 설정 코드
    ///
    /// ***i.e.*** self.title = "title"
    func setupStyles() {
        self.view.backgroundColor = .gray700
    }
    
    /// ViewModel 바인딩에 필요한 코드
    func bind() { }
}

extension BaseViewController {
    
    private func setUpContentView() {
        [contentNavigationBar, contentView].forEach { self.view.addSubview($0) }
    }
    
    private func setUpContentLayout() {
        
        contentNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(showNavigaitonBar ? SPNavigationBarView.height : 0)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(contentNavigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension BaseViewController {
    
    func setNavigationBarItem(title: String?, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        self.contentNavigationBar = SPNavigationBarView(title ?? "", leftIcon: leftIcon, rightIcon: rightIcon)
        self.showNavigaitonBar = true
    }
}
