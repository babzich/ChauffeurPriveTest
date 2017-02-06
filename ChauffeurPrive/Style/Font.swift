//
//  Font.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit

enum Font {
    enum System {
        case regular
        case bold
        case semiBold
        
        func of(size: CGFloat) -> UIFont {
            switch self {
            case .regular:
                return UIFont.systemFont(ofSize: size)
            case .bold:
                return UIFont.boldSystemFont(ofSize: size)
            case .semiBold:
                return UIFont.systemFont(ofSize: size, weight:UIFontWeightSemibold)
            }
        }
    }
}
