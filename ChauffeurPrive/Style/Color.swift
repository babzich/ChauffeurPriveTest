//
//  Color.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit

enum Color {
    static let black = UIColor.black
    static let white = UIColor.white
    static let blue = UIColor.hex(0x009FE8)
}

extension UIColor {
    static func hex(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex & 0x0000FF       ) / divisor
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
