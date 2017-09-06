//
//  UIColor.swift
//  FieldService
//
//  Created by Jason Wells on 9/2/15.
//  Copyright (c) 2015 Salesforce Services. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex6: String, alpha: CGFloat = 1) {
        var hexInt: CUnsignedInt = 0
        let scanner: Scanner = Scanner(string: hex6)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        let red: CGFloat = CGFloat((hexInt >> 16) & 0xFF) / 255;
        let green: CGFloat = CGFloat((hexInt >> 8) & 0xFF) / 255;
        let blue: CGFloat = CGFloat((hexInt) & 0xFF) / 255;
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
 
    //an alpha value specifed in hex overrides input param
    convenience init(hex: String, alpha: CGFloat = 1) {
        var hexInt: CUnsignedInt = 0
        let scanner: Scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let includesAlpha = hex.characters.count > 7
        if includesAlpha
        {
            let red: CGFloat = CGFloat((hexInt >> 24) & 0xFF) / 255;
            let green: CGFloat = CGFloat((hexInt >> 16) & 0xFF) / 255;
            let blue: CGFloat = CGFloat((hexInt >> 8) & 0xFF) / 255;
            let hexAlpha: CGFloat = CGFloat((hexInt) & 0xFF) / 255;
            self.init(red: red, green: green, blue: blue, alpha: hexAlpha)
        }
        else
        {
            let red: CGFloat = CGFloat((hexInt >> 16) & 0xFF) / 255;
            let green: CGFloat = CGFloat((hexInt >> 8) & 0xFF) / 255;
            let blue: CGFloat = CGFloat((hexInt) & 0xFF) / 255;
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    func colorWithSaturationComponentReducedByFactor(_ factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            saturation = saturation <= 0 ? saturation : saturation * 255 / factor / 255
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        return self
    }
    
    func colorWithBrightnessComponentReducedByFactor(_ factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            brightness = brightness <= 0 ? brightness : brightness * 255 / factor / 255
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        return self
    }
    
}
