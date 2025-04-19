//
//  MyPageViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import Foundation

import Dependencies
import RxCompose
import RxSwift
import RxCocoa

final class MyPageViewModel: Composer {
    enum Action {
        case viewDidAppear
        case mutatedProfile(ProfileEntity)
        case mutatedSubscribedArtistsCount(Int)
        case mutatedSubscribedGenresCount(Int)
        case fetchProfileError
    }
    
    struct State {
        var nickname: String?
        var subscribedArtistsCount: Int = 0
        var subscribedGenresCount: Int = 0
        @PresentState
        var isProfileLoading: Bool = true
        @PresentState
        var isGenresCountLoading: Bool = true
        @PresentState
        var isArtistsCountLoading: Bool = true
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    @Dependency(MyPageUseCase.self)
    private var useCase
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidAppear:
            state.isProfileLoading = true
            state.isGenresCountLoading = true
            state.isArtistsCountLoading = true
            return fetchProfile()
        case let .mutatedProfile(profile):
            state.nickname = profile.nickname
            state.isProfileLoading = false
            return .merge(
                fetchGenresSubscriptionCount(),
                fetchArtistsSubscriptionCount()
            )
        case let .mutatedSubscribedArtistsCount(count):
            state.subscribedArtistsCount = count
            state.isArtistsCountLoading = false
            return .none
        case let .mutatedSubscribedGenresCount(count):
            state.subscribedGenresCount = count
            state.isGenresCountLoading = false
            return .none
        case .fetchProfileError:
            state.nickname = nil
            state.subscribedArtistsCount = 0
            state.subscribedGenresCount = 0
            return .none
        }
    }
}

// MARK: - functions
private extension MyPageViewModel {
    func fetchArtistsSubscriptionCount() -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.artistsSubscriptionCount()
            effect.onNext(.send(.mutatedSubscribedArtistsCount(response)))
        } catch: { error in
            print(error)
            return .none
        }
    }
    
    func fetchGenresSubscriptionCount() -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.genresSubscriptionCount()
            effect.onNext(.send(.mutatedSubscribedGenresCount(response)))
        } catch: { error in
            print(error)
            return .none
        }
    }
    
    func fetchProfile() -> Observable<Effect<Action>> {
        return .run { [useCase = self.useCase] effect in
            let response = try await useCase.profile()
            effect.onNext(.send(.mutatedProfile(response)))
        } catch: { error in
            print(error)
            return .send(.fetchProfileError)
        }
    }
}
