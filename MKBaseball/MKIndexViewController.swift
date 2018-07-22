//
//  MKIndexViewController.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/17.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import SnapKit

class MKIndexViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        
        view.addSubview(headerLogoImageView)
        
        let todayViewController = MKTodayViewController()
        todayViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 100)
        
        let secondViewController = UIViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 200)
        secondViewController.view.backgroundColor = UIColor.brown
        
        self.viewControllers = [todayViewController, secondViewController]
        
        setupConstraints()
    }
    
    private lazy var headerLogoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "cpbl_logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

}

private extension MKIndexViewController {
    func setupConstraints() {
        headerLogoImageView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalTo(view.snp.topMargin)
            }
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
        }
    }
}

extension UIColor {
    convenience init(r: UInt, g: UInt, b: UInt, a: CGFloat) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
    }
    
    static let cpblBlue = UIColor(r: 45, g: 71, b: 146, a: 0.7)
}
