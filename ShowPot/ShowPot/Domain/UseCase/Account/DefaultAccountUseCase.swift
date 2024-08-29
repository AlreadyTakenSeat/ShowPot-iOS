//
//  DefaultAccountUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import RxSwift
import RxCocoa

final class DefaultAccountUseCase: AccountUseCase {
    
    private let apiService: SPUserAPI
    private let disposeBag = DisposeBag()
    
    var logoutResult = PublishSubject<Bool>()
    var deleteAccountResult = PublishSubject<Bool>()
    
    init(apiService: SPUserAPI = SPUserAPI()) {
        self.apiService = apiService
    }
    
    func logout() {
        apiService.logout()
            .subscribe { response in
                self.logoutResult.onNext(true)
                TokenManager.shared.deleteTokens()
                UserDefaultsManager.shared.remove(for: .userProfileInfo)
            } onError: { error in
                self.logoutResult.onNext(false)
            }
            .disposed(by: disposeBag)
    }
    
    func deleteAccount() {
        apiService.withdrawal()
            .subscribe { response in
                self.deleteAccountResult.onNext(true)
                TokenManager.shared.deleteTokens()
                UserDefaultsManager.shared.remove(for: .userProfileInfo)
            } onError: { error in
                self.deleteAccountResult.onNext(false)
            }
            .disposed(by: disposeBag)
    } 
}
