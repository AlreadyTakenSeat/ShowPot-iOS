//
//  ReusableCell.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/17/24.
//

import Foundation
import UIKit

/// class 이름을 reuseIdentifier로 자동으로 만들어주는 Protocol
protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

// MARK: UICollectionView & UITableView 실 사용부
extension UICollectionView {
    
    /// Register UICollectionViewCell that conforms ReusableCell to UICollectionView using reuseIdentifier
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableCell {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    /// Get dequeueReusableCell of UICollectionViewCell that conforms ReusableCell using reuseIdentifier
    func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T? where T: ReusableCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            LogHelper.debug("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            return nil
        }

        return cell
    }
}

extension UITableView {
    /// Register UITableViewCell that conforms ReusableCell to UITableView using reuseIdentifier
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableCell {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    /// Get dequeueReusableCell of UITableViewCell that conforms ReusableCell using reuseIdentifier
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T? where T: ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            LogHelper.debug("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            return nil
        }

        return cell
    }
}
