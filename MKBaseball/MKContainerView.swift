//
//  MKContainerView.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/21.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKContainerView: UIView {
    
    private let separatorColor = UIColor.gray
    private let separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private let separatorHeight: CGFloat = 1.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isOpaque = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        
        // Fill background color with background color set by user
        if let backgroundColor = self.backgroundColor {
            backgroundColor.setFill()
            UIRectFill(rect)
        }
        
        // Draw separator
        separatorColor.set()
        context?.setLineWidth(separatorHeight * UIScreen.main.scale)
        context?.move(to: CGPoint(x: separatorInset.left, y: rect.size.height))
        context?.addLine(to: CGPoint(x: rect.size.width - separatorInset.right, y: rect.size.height))
        context?.strokePath()
    }
}
