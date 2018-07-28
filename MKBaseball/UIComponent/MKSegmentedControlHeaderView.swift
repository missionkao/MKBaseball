//
//  MKSegmentedControlHeaderView.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/28.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKSegmentedControlHeaderView: MKContainerView {
    
    private let items: [String]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        separatorInset = .zero
        addSubview(selectionView)
        
        selectionView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(36)
        }
    }
    
    private lazy var selectionView: UISegmentedControl = {
        let view = UISegmentedControl(items: items)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor.cpblBlue
        view.selectedSegmentIndex = 0
        var attributes = [NSAttributedStringKey: Any]()
        attributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 16)
        view.setTitleTextAttributes(attributes, for: .normal)
        return view
    }()
}
