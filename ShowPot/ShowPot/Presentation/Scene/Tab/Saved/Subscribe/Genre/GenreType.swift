//
//  GenreType.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/9/24.
//

import UIKit

enum GenreType: String {
    
    case rock, band, edm, classic, hiphop, house, opera, pop, rnb, musical, metal, jpop, jazz
    
    var title: String {
        switch self {
        case .rnb:
            return "R&B"
        case .jpop:
            return "J-POP"
        default:
            return self.rawValue.uppercased()
        }
    }
    
    var normalImage: UIImage? {
        return UIImage(named: "genre_\(self.rawValue)")
    }
    
    var selectedImage: UIImage? {
        return UIImage(named: "genre_selected_\(self.rawValue)")
    }
    
    var subscribedImage: UIImage? {
        return UIImage(named: "genre_subscribed_\(self.rawValue)")
    }
}

extension UICollectionViewCell {
    
    func genreImage(type: GenreType) -> UIImage? {
        
        if isSelected {
            return type.selectedImage
        }
        
        if isHighlighted {
            return type.subscribedImage
        }
        
        return type.normalImage
    }
}
