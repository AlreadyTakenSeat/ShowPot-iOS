//
//  DefaultSignInUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/27/24.
//

import RxSwift
import RxCocoa

final class DefaultSignInUseCase: SignInUseCase {
    
    private let apiSevice: APIClient
    private let disposeBag = DisposeBag()
    
    var signInResult: PublishRelay<Bool> = PublishRelay<Bool>()
    
    init(apiSevice: APIClient = APIClient()) {
        self.apiSevice = apiSevice
    }
    
    func signIn(request: SignInRequest) {
        apiSevice.login(request: .init(
            socialType: request.socialType,
            identifier: request.identifier,
            fcmToken: request.fcmToken
        ))
        .subscribe(with: self) { owner, response in
            TokenManager.shared.createTokens(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )
            owner.signInResult.accept(true)
        }
        .disposed(by: disposeBag)
    }
}
