//
//  OnboardingUseCase.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/29/24.
//

import Foundation
import UIKit

/// 온보딩 페이지별 표출될 컨텐츠 관리에 사용할 구조체
struct OnboardingData {
    let image: UIImage
    let title: String
    let description: String
    let backgroundColor: UIColor
}

protocol OnboardingUseCase {
    var carouselData: [OnboardingData] { get }
}
