// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  /// Localizable.strings
  ///   ShowPot
  /// 
  ///   Created by Daegeon Choi on 5/25/24.
  public static let appName = Strings.tr("Localizable", "app_name", fallback: "쇼팟")
  /// 관심 있는 공연과 가수를 검색해보세요
  public static let homeSearchbarPlaceholder = Strings.tr("Localizable", "home_searchbar_placeholder", fallback: "관심 있는 공연과 가수를 검색해보세요")
  /// 아티스트 구독하기
  public static let homeSubscribeArtistTitle = Strings.tr("Localizable", "home_subscribe_artist_title", fallback: "아티스트 구독하기")
  /// 장르 구독하기
  public static let homeSubscribeGenreTitle = Strings.tr("Localizable", "home_subscribe_genre_title", fallback: "장르 구독하기")
  /// 전체공연 보러가기
  public static let homeTicketingPerformanceButtonTitle = Strings.tr("Localizable", "home_ticketing_performance_buttonTitle", fallback: "전체공연 보러가기")
  /// 티켓팅이 얼마 남지 않은 공연
  public static let homeTicketingPerformanceTitle = Strings.tr("Localizable", "home_ticketing_performance_title", fallback: "티켓팅이 얼마 남지 않은 공연")
  /// 쇼팟 시작하기
  public static let onboardingButton = Strings.tr("Localizable", "onboarding_button", fallback: "쇼팟 시작하기")
  /// 중요한 티켓팅, 잊어버리지 않게
  /// 푸쉬 알림을 드릴게요!
  public static let onboardingDescription1 = Strings.tr("Localizable", "onboarding_description_1", fallback: "중요한 티켓팅, 잊어버리지 않게\n푸쉬 알림을 드릴게요!")
  /// 내가 관심 있는 장르/아티스트의
  /// 내한 소식을 빠르게 받아볼 수 있어요!
  public static let onboardingDescription2 = Strings.tr("Localizable", "onboarding_description_2", fallback: "내가 관심 있는 장르/아티스트의\n내한 소식을 빠르게 받아볼 수 있어요!")
  /// 티켓팅 알림받기
  public static let onboardingTitle1 = Strings.tr("Localizable", "onboarding_title_1", fallback: "티켓팅 알림받기")
  /// 장르/아티스트 구독하기
  public static let onboardingTitle2 = Strings.tr("Localizable", "onboarding_title_2", fallback: "장르/아티스트 구독하기")
  /// Apple로 시작하기
  public static let socialLoginAppleButton = Strings.tr("Localizable", "socialLogin_apple_button", fallback: "Apple로 시작하기")
  /// 잊지않고 내한공연 즐기러가요
  public static let socialLoginDescription = Strings.tr("Localizable", "socialLogin_description", fallback: "잊지않고 내한공연 즐기러가요")
  /// Google로 시작하기
  public static let socialLoginGoogleButton = Strings.tr("Localizable", "socialLogin_google_button", fallback: "Google로 시작하기")
  /// Kakao로 시작하기
  public static let socialLoginKakaoButton = Strings.tr("Localizable", "socialLogin_kakao_button", fallback: "Kakao로 시작하기")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
