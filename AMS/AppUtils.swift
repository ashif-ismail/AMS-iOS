//
//  AppUtils.swift
//  AMS
//
//  Created by DOT Developer DOT on 05/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import Foundation
import UIKit

class AppUtils {
    public static func resolveUserType(userType: Int) -> String {
        if userType == 3 {
            return "chairman"
        } else if userType == 4 {
            return "ceo"
        } else {
            return "hr"
        }
    }
    
    public static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    enum AppConstants: String {
        case BASE_URL = "https://demo2.wowdle.com/alotaiba/api/v1/"
    }
}


