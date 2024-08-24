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
    
    private let versionAlertRelay = PublishRelay<String>()
    var settingModel: [SettingType] {
        [.version, .account, .alarm, .privacyPolicy, .term, .kakao]
    }
    
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let didTappedBackButton: Observable<Void>
        let didTappedSettingCell: Observable<IndexPath>
    }
    
    struct Output {
        let versionAlertMessage: Signal<String>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(with: self) { owner, _ in
                owner.isUpdateAvailable {
                    owner.versionAlertRelay.accept($0 ? "업데이트가 필요합니다" : "최신버전 입니다")
                }
            }
            .disposed(by: disposeBag)
        
        input.didTappedBackButton
            .subscribe(with: self) { owner, _ in
                owner.coordinator.popViewController()
            }
            .disposed(by: disposeBag)
        
        input.didTappedSettingCell
            .subscribe(with: self) { owner, indexPath in
                switch owner.settingModel[indexPath.row] {
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
        
        return Output(versionAlertMessage: versionAlertRelay.asSignal(onErrorSignalWith: .empty()))
    }
}

extension SettingViewModel {
    
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
            return "계정"
        case .alarm:
            return "알림 설정"
        case .privacyPolicy:
            return "개인정보 처리 방침"
        case .term:
            return "이용 약관"
        case .kakao:
            return "카카오 문의하기"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .version:
            return .icInfo.withTintColor(.gray400)
        case .account:
            return .icProfile.withTintColor(.gray400)
        case .alarm:
            return .icAlarm.withTintColor(.gray400)
        case .privacyPolicy:
            return .icPrivacy.withTintColor(.gray400)
        case .term:
            return .icReport.withTintColor(.gray400)
        case .kakao:
            return .icHeadphone.withTintColor(.gray400)
        }
    }
}

