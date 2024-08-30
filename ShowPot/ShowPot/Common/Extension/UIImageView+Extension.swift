//
//  UIImageView+Extension.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/17/24.
//

import UIKit

extension UIImageView {
    
    enum RelativeSizeOption {
        case relativeHeight, relativeWidth
    }
    
    func setImage(urlString: String, option: RelativeSizeOption? = nil) {
        guard let url = URL(string: urlString) else { return }
        self.kf.setImage(with: url, options: [.callbackQueue(.mainAsync)]) { result in
            switch result {
            case .success(let value):
                guard let option else { return }
                self.setRelativeSize(imageSize: value.image.size, option: option)
            case .failure(let error):
                LogHelper.debug(error.localizedDescription)
            }
        }
    }
    
    private func setRelativeSize(imageSize: CGSize, option: RelativeSizeOption) {
        switch option {
        case .relativeHeight:
            self.setRelativeHeight(imageSize: imageSize)
        case .relativeWidth:
            self.setRelativeWidth(imageSize: imageSize)
        }
    }
    
    private func setRelativeHeight(imageSize: CGSize) {
        let multiply = imageSize.height / imageSize.width
        let height = self.bounds.width * multiply
        
        self.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

    private func setRelativeWidth(imageSize: CGSize) {
        let multiply = imageSize.width / imageSize.height
        let height = self.bounds.height * multiply
        
        self.snp.updateConstraints { make in
            make.width.equalTo(height)
        }
    }
}
