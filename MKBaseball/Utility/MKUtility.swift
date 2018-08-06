//
//  MKUtility.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/26.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: UInt, g: UInt, b: UInt, a: CGFloat) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
    }
    
    static let cpblBlue = UIColor(r: 45, g: 71, b: 126, a: 1.0)
}

extension Date {
    init(_ year: Int, _ month: Int, _ day: Int) {
        let dateString = "\(year)-\(month)-\(day)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self = dateFormatter.date(from: dateString)!
    }
}
