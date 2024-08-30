//
//  AccountUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import RxSwift
import RxCocoa

protocol AccountUseCase {
    
    var logoutResult: PublishSubject<Bool> { get }
    var deleteAccountResult: PublishSubject<Bool> { get }
    
    func logout()
    func deleteAccount()
}

