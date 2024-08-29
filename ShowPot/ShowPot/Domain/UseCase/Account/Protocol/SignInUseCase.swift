//
//  SignInUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/27/24.
//

import RxSwift
import RxCocoa

protocol SignInUseCase {
    
    var signInResult: PublishRelay<Bool> { get }
    
    func signIn(request: SignInRequest)
    func getProfileInfo()
}

struct UserProfileInfo: Codable {
    let nickName: String
    let socialType: String
}
