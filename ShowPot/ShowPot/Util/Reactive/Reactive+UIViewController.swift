//
//  Reactive+UIViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    func pushViewController(animated: Bool) -> Binder<UIViewController> {
        Binder(base) { base, viewController in
            base.navigationController?.pushViewController(
                viewController,
                animated: animated
            )
        }
    }
    
    func presentViewController(animated: Bool) -> Binder<UIViewController> {
        Binder(base) { base, viewController in
            base.present(viewController, animated: animated)
        }
    }
    
    func presentAlert(title: String?, actions: UIAlertAction...) -> Binder<String?> {
        Binder(base) { base, message in
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            for action in actions {
                alert.addAction(action)
            }
            base.present(alert, animated: true)
        }
    }
    
    func popViewController(animated: Bool) -> Binder<Void> {
        Binder(base) { base, _ in
            base.navigationController?.popViewController(animated: animated)
        }
    }
    
    func dismiss(animated: Bool) -> Binder<Void> {
        Binder(base) { base, _ in
            base.dismiss(animated: animated)
        }
    }
}
