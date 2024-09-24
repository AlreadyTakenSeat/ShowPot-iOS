//
//  SettingViewModel.swift
//  ShowPot
//
//  Created by 이건준 on 8/25/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    var coordinator: SettingCoordinator
    
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let didTappedBackButton: Observable<Void>
        let didTappedSettingCell: Observable<IndexPath>
        let refreshSettings: Observable<Void>
    }
    
    struct Output {
        let versionDescription = PublishRelay<(index: Int, description: String)>()
        let settingModel = BehaviorRelay<[SettingType]>(value: [])
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSettingCell
            .subscribe(with: self) { owner, indexPath in
                switch output.settingModel.value[indexPath.row] {
                case .version:
                    LogHelper.debug("버전 셀 클릭")
                case .account:
                    owner.coordinator.goToAccountScreen()
                case .alarm:
                    owner.coordinator.goToAppSettings()
                case .privacyPolicy:
                    owner.coordinator.goToPolicyNotionPage()
                case .term:
                    owner.coordinator.goToTermNotionPage()
                case .kakao:
                    owner.coordinator.goToKakaoChanel()
                }
            }
            .disposed(by: disposeBag)
        
        input.refreshSettings
            .subscribe(with: self) { owner, _ in
                owner.isUpdateAvailable {
                    owner.updateVersionDescription(isUpdateAvailable: $0, output: output)
                }

                owner.updateSettingModel(output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension SettingViewModel {
    
    private func updateVersionDescription(isUpdateAvailable: Bool, output: Output) {
        let settingModel = output.settingModel.value
        guard let versionIndex = settingModel.firstIndex(where: { $0 == .version }) else { return }

        let description = isUpdateAvailable
            ? Strings.settingVersionOutOfDateTitle
            : Strings.settingVersionUpToDateTitle

        output.versionDescription.accept((versionIndex, description))
    }

    private func updateSettingModel(output: Output) {
        let loggedInSettings: [SettingType] = [.version, .account, .alarm, .privacyPolicy, .term, .kakao]
        let loggedOutSettings: [SettingType] = [.version, .alarm, .privacyPolicy, .term, .kakao]

        output.settingModel.accept(LoginState.current == .loggedIn ? loggedInSettings : loggedOutSettings)
    }
    
    private func isUpdateAvailable(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(Environment.bundleID)") else {
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appInfo = results.first,
                  let appStoreVersion = appInfo["version"] as? String else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            let isUpdateAvailable = Environment.appVersion != appStoreVersion
            DispatchQueue.main.async {
                completion(isUpdateAvailable)
            }
        }.resume()
    }
}

enum SettingType {
    case version
    case account
    case alarm
    case privacyPolicy
    case term
    case kakao
    
    var title: String {
        switch self {
        case .version:
            return "버전 \(Environment.appVersion)"
        case .account:
            return Strings.settingAccountMenuTitle
        case .alarm:
            return Strings.settingAlarmMenuTitle
        case .privacyPolicy:
            return Strings.settingPrivacyPolicyMenuTitle
        case .term:
            return Strings.settingTermMenuTitle
        case .kakao:
            return Strings.settingKakaoMenuTitle
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .version:
            return .icInfo.withTintColor(.gray400)
        case .account:
            return .icProfile.withTintColor(.gray400)
        case .alarm:
            return .icAlarmSmall.withTintColor(.gray400)
        case .privacyPolicy:
            return .icPrivacy.withTintColor(.gray400)
        case .term:
            return .icReport.withTintColor(.gray400)
        case .kakao:
            return .icHeadphone.withTintColor(.gray400)
        }
    }
}

