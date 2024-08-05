//
//  BaseViewController+BottomSheet.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/5/24.
//

import UIKit

extension BaseViewController {
    
    /// 로그인 제안 바텀시트 표출
    func showLoginBottomSheet() {
        let loginBottomSheet = SPDefaultBottomSheetViewController(
            message: Strings.bottomSheetLoginMessage,
            buttonTitle: Strings.bottomSheetLoginButtonTitle
        )
        
        loginBottomSheet.didTapBottomButton.subscribe { _ in
            
            guard let navigationController = self.navigationController else {
                fatalError("Navigation Controller Missing")
            }
            
            loginBottomSheet.dismissBottomSheet()
            
            let coordinator = LoginCoordinator(navigationController: navigationController)
            coordinator.start()
        }
        .disposed(by: disposeBag)
        
        self.presentBottomSheet(viewController: loginBottomSheet)
    }
}
