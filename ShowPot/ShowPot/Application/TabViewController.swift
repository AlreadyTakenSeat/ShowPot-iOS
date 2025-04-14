//
//  TabViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/7/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class TabViewController: UITabBarController {
    private let spTabBar = SPTabBar(tabItems: [
        TabItem(normalImage: .icHome, selectedImage: .icHomeFilled, title: "홈"),
        TabItem(normalImage: .icShow, selectedImage: .icShowFilled, title: "내 공연"),
        TabItem(normalImage: .icMy, selectedImage: .icMyFilled, title: "마이")
    ])
    private let disposeBag = DisposeBag()
    // 버튼의 제약 조건을 동적으로 변경하기 위해 저장
    private var tabBarBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        
        configureTabBar()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
    }
}

// MARK: Configure Views
private extension TabViewController {
    func configureTabBar() {
        view.addSubview(spTabBar)
        
        tabBar.isHidden = true
        
        spTabBar.snp.makeConstraints { make in
            tabBarBottomConstraint = make.bottom.equalToSuperview().constraint
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }
        
        spTabBar.selectedIndex
            .observe(on: MainScheduler.instance)
            .bind(with: self) { this, index in
                this.selectedIndex = index
            }
            .disposed(by: disposeBag)
    }
    
    func configureViewController() {
        let homeViewController = UINavigationController(
            rootViewController: HomeViewController()
        )
        homeViewController.delegate = self
        let myShowViewController = UINavigationController(
            rootViewController: MyShowViewController()
        )
        myShowViewController.delegate = self
        let myPageViewController = UINavigationController(
            rootViewController: MyPageViewController()
        )
        myPageViewController.delegate = self
        let viewControllers = [
            homeViewController,
            myShowViewController,
            myPageViewController
        ]
        
        for child in viewControllers {
            child.navigationBar.isHidden = true
        }
        
        setViewControllers(viewControllers, animated: true)
    }
}

extension TabViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count > 1 {
            tabBarBottomConstraint?.update(offset: 100)
            UIView.fadeAnimate(duration: 0.4) { [weak self] in
                self?.spTabBar.alpha = 0
                self?.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.spTabBar.isHidden = true
            }
        } else {
            tabBarBottomConstraint?.update(offset: 0)
            spTabBar.isHidden = false
            UIView.fadeAnimate(duration: 0.4) { [weak self] in
                self?.spTabBar.alpha = 1
                self?.view.layoutIfNeeded()
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    TabViewController()
}
