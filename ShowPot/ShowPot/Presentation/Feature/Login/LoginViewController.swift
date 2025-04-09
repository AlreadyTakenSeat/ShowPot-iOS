//
//  LoginViewController.swift
//  ShowPot
//
//  Created by 김도형 on 4/8/25.
//

import UIKit

import SnapKit
import RxCompose
import RxSwift
import RxCocoa
import RxGesture

final class LoginViewController: UIViewController, Composable {
    // MARK: - Properties
    private let backButton = UIButton()
    private let logoImageView = UIImageView()
    private let subtitleLabel = UILabel()
    private let drumImageView = UIImageView()
    private let buttonStackView = UIStackView()
    
    // 로그인 버튼 프로퍼티 추가
    private let kakaoLoginButton = UIButton()
    private let googleLoginButton = UIButton()
    private let appleLoginButton = UIButton()
    
    @Compose
    var composer = LoginViewModel()
    var disposeBag = DisposeBag()

    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindAction()
    }
}

// MARK: - Configure View
private extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .gray700 // 배경색 설정
        
        configureBackButton()
        
        configureLogoImageView()
        
        configureSubtitleLabel()
        
        configureDrumImageView()
        
        configureButtonStackView()
    }
    
    func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().inset(6)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
            make.width.equalTo(136) // 이미지 크기 설정 (적절히 조정)
            make.height.equalTo(54)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        drumImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(42)
            make.horizontalEdges.equalToSuperview().inset(106)
            make.height.equalTo(200)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(56)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureBackButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icArrowLeft.resized(
            to: CGSize(width: 36, height: 36)
        ).withTintColor(.white)
        configuration.contentInsets = .zero
        backButton.configuration = configuration
        view.addSubview(backButton)
    }
    
    func configureLogoImageView() {
        logoImageView.image = .logoTitle // "Showpot" 로고 이미지 (프로젝트에 맞게 변경 필요)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        view.addSubview(logoImageView)
    }
    
    func configureSubtitleLabel() {
        let attributedString = NSAttributedString(
            "잊지않고 내한공연 즐기러가요",
            fontType: KRFont.H2,
            alignment: .center
        ).setForegroundColor(color: .white) // 흰색으로 설정
        subtitleLabel.attributedText = attributedString
        view.addSubview(subtitleLabel)
    }
    
    func configureDrumImageView() {
        drumImageView.image = .loginCenter // 실제 이미지 이름으로 변경 필요
        drumImageView.contentMode = .scaleAspectFit
        view.addSubview(drumImageView)
    }
    
    func configureButtonStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        
        configureKakaoLoginButton()
//        configureGoogleLoginButton()
        configureAppleLoginButton()
        
        buttonStackView.addArrangedSubview(kakaoLoginButton)
//        buttonStackView.addArrangedSubview(googleLoginButton)
        buttonStackView.addArrangedSubview(appleLoginButton)
        
        view.addSubview(buttonStackView)
    }
    
    func configureKakaoLoginButton() {
        var kakaoConfig = UIButton.Configuration.filled()
        kakaoConfig.background.backgroundColor = .btnBgSocialKakao // 노란색
        kakaoConfig.background.cornerRadius = 2
        kakaoConfig.image = .icKakao.resized(
            to: CGSize(width: 24, height: 24)
        ) // 카카오 아이콘 이미지 필요
        kakaoConfig.imagePadding = 12
        kakaoConfig.imagePlacement = .leading
        kakaoConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 0,
            bottom: 14,
            trailing: 0
        )
        let kakaoTitle = NSAttributedString(
            "카카오로 시작하기",
            fontType: KRFont.H2,
            alignment: .center
        ).setForegroundColor(color: .black)
        kakaoConfig.attributedTitle = AttributedString(kakaoTitle)
        kakaoLoginButton.configuration = kakaoConfig
    }
    
    func configureGoogleLoginButton() {
        var googleConfig = UIButton.Configuration.filled()
        googleConfig.background.backgroundColor = .btnBgSocialGoogle
        googleConfig.background.cornerRadius = 2
        googleConfig.image = .icGoogle.resized(
            to: CGSize(width: 24, height: 24)
        ) // 구글 아이콘 이미지 필요
        googleConfig.imagePadding = 12
        googleConfig.imagePlacement = .leading
        googleConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 0,
            bottom: 14,
            trailing: 0
        )
        let googleTitle = NSAttributedString(
            "Google로 시작하기",
            fontType: KRFont.H2,
            alignment: .center
        ).setForegroundColor(color: .black)
        googleConfig.attributedTitle = AttributedString(googleTitle)
        googleLoginButton.configuration = googleConfig
    }
    
    func configureAppleLoginButton() {
        var appleConfig = UIButton.Configuration.filled()
        appleConfig.background.backgroundColor = .black
        appleConfig.background.cornerRadius = 2
        appleConfig.background.strokeWidth = 1
        appleConfig.background.strokeColor = .gray100
        appleConfig.image = .icApple.withTintColor(.white).resized(
            to: CGSize(width: 24, height: 24)
        )
        appleConfig.imagePadding = 12
        appleConfig.imagePlacement = .leading
        appleConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 0,
            bottom: 14,
            trailing: 0
        )
        let appleTitle = NSAttributedString(
            "Apple로 시작하기",
            fontType: KRFont.H2,
            alignment: .center
        ).setForegroundColor(color: .white)
        appleConfig.attributedTitle = AttributedString(appleTitle)
        appleLoginButton.configuration = appleConfig
    }
}

// MARK: - Bind
private extension LoginViewController {
    func bindAction() {
        // 뒤로가기 버튼
        backButton.rx.tap
            .bind(to: rx.popViewController(animated: true))
            .disposed(by: disposeBag)
        
        // 카카오 버튼
        kakaoLoginButton.rx.tap
            .map { Action.kakaoLoginButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        // 구글 버튼
        googleLoginButton.rx.tap
            .map { Action.googleLoginButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
        
        // 애플 버튼
        appleLoginButton.rx.tap
            .map { Action.appleLoginButtonTapped }
            .bind(to: composer.action)
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginViewController()
}
