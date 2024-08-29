//
//  DefaultSignInUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/27/24.
//

import RxSwift
import RxCocoa

final class DefaultSignInUseCase: SignInUseCase {
    
    private let apiSevice: SPUserAPI
    private let disposeBag = DisposeBag()
    
    var signInResult: PublishRelay<Bool> = PublishRelay<Bool>()
    
    init(apiSevice: SPUserAPI = SPUserAPI()) {
        self.apiSevice = apiSevice
    }
    
    func signIn(request: SignInRequest) {
        apiSevice.login(
            socialType: request.socialType,
            identifier: request.identifier
        )
        .subscribe(with: self) { owner, response in
            TokenManager.shared.createTokens(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            owner.signInResult.accept(true)
            owner.getProfileInfo()
        }
        .disposed(by: disposeBag)
    }
    
    func getProfileInfo() {
        apiSevice.profileInfo()
            .subscribe(with: self) { owner, response in
                UserDefaultsManager.shared.set(
                    UserProfileInfo(
                        nickName: response.nickname,
                        socialType: response.type
                    ),
                    forKey: .userProfileInfo
                )
            }
            .disposed(by: disposeBag)
    }
}
