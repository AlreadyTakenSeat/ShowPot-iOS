//
//  DefaultOnboardingUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/29/24.
//

import Foundation

final class DefaultOnboardingUseCase: OnboardingUseCase {
    /// Carousel Cell에 들어갈 데이터
    let carouselData: [OnboardingData] = [
        OnboardingData(
            image: .onboarding1,
            title: Strings.onboardingTitle1, description: Strings.onboardingDescription1,
            backgroundColor: .mainOrange
        ),
        OnboardingData(
            image: .onboarding2,
            title: Strings.onboardingTitle2, description: Strings.onboardingDescription2,
            backgroundColor: .mainGreen
        )
    ]
}
