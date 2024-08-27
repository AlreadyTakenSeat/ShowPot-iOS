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
    
    var id: String {
        switch self {
        case .rock:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d1"
        case .band:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d3"
        case .edm:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d7"
        case .classic:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876dc"
        case .hiphop:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d2"
        case .house:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d6"
        case .opera:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876da"
        case .pop:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d5"
        case .rnb:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d9"
        case .musical:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d8"
        case .metal:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876db"
        case .jpop:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d4"
        case .jazz:
            return "017f20d0-4f3c-8f4d-9e15-7ff0c3a876dd"
        }
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
