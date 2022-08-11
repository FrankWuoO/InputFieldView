//
//  UIColor+InputFieldView.swift
//  InputFieldView
//
//  Created by cheng-en wu on 2022/8/5.
//

import Foundation

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
    
    static var titleNormalColor: UIColor {
        return UIColor(hex: 0x252729)
    }
}
