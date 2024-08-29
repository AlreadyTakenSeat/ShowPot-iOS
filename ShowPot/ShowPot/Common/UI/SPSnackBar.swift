//
//  SPSnackBar.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/29/24.
//

import UIKit

/// 지정된 Snackbar 유형
enum SPSnackBarType {
    /// 구독 설정 완료
    case subscribe
    /// 알림 설정 완료
    case alarm
    /// 로그인 완료
    case signIn
    /// 로그아웃 완료
    case signOut
    /// 회월탈퇴 완료
    case deleteAccount
    
    var icon: UIImage? {
        return .icCheck.withTintColor(.gray200)
    }
    
    var message: String {
        switch self {
        case .subscribe:
            return Strings.snackbarDescriptionSubscribe
        case .alarm:
            return Strings.snackbarDescriptionAlarm
        case .signIn:
            return Strings.snackbarDescriptionLogin
        case .signOut:
            return Strings.snackbarDescriptionLogout
        case .deleteAccount:
            return Strings.snackbarDescriptionWithdraw
        }
    }
    
    var actionTitle: String {
        return Strings.snackbarActionTitle
    }
    
    var duration: SnackBar.Duration {
        return .short
    }
}

/// ShowPot 앱 전용 SnackBar
final class SPSnackBar: SnackBar {

    init(contextView: UIView, type: SPSnackBarType) {
        
        let snackBarStyle = SnackBarStyle(
            icon: type.icon,
            message: type.message,
            actionTitle: type.actionTitle
        )
        
        let duration = type.duration
        
        super.init(contextView: contextView, style: snackBarStyle, duration: duration)
    }
    
    required init(contextView: UIView, style: SnackBarStyle, duration: Duration) {
        fatalError("init(contextView:style:duration:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
