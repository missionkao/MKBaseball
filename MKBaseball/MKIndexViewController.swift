//
//  MKIndexViewController.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/17.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import SnapKit

// WIP:
// 1. news pagnation
// 2. today, tomorrow pither or hitter

class MKIndexViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        tabBar.backgroundColor = UIColor.white
        
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.gray.cgColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.cpblBlue], for: .selected)
        
        view.addSubview(headerLogoImageView)
        
        let topViewController = MKTodayViewController(viewModel: MKTodayViewModel())
        topViewController.tabBarItem = topTabBarItem
        
        let calendarViewController = MKScheduleViewController(viewModel: MKScheduleViewModel())
        calendarViewController.tabBarItem = calendarTabBarItem
        
        let rankingViewController = MKRankingViewController(viewModel: MKRankingViewModel())
        rankingViewController.tabBarItem = rankingTabBarItem
        
        let statsViewController = MKStatisticViewController(viewModel: MKStatisticViewModel())
        statsViewController.tabBarItem = statsTabBarItem
        
        let newsViewController = MKNewsViewController(viewModel: MKNewsViewModel())
        newsViewController.tabBarItem = newsTabBarItem
        
        self.viewControllers = [topViewController, calendarViewController, rankingViewController, statsViewController, newsViewController]
        
        setupConstraints()
    }
    
    private lazy var headerLogoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "cpbl_logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var topTabBarItem: UITabBarItem = {
        return tabBarItem(titel: "Top", imageName: "tab_bar_top")
    }()
    
    private lazy var calendarTabBarItem: UITabBarItem = {
        return tabBarItem(titel: "Calendar", imageName: "tab_bar_calendar")
    }()
    
    private lazy var rankingTabBarItem: UITabBarItem = {
        return tabBarItem(titel: "Ranking", imageName: "tab_bar_ranking")
    }()
    
    private lazy var statsTabBarItem: UITabBarItem = {
        return tabBarItem(titel: "Stats", imageName: "tab_bar_stats")
    }()
    
    private lazy var newsTabBarItem: UITabBarItem = {
        return tabBarItem(titel: "News", imageName: "tab_bar_news")
    }()
    
    private lazy var videoTabBarItem: UITabBarItem = {
        return tabBarItem(titel: "Video", imageName: "tab_bar_video")
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
    
    func tabBarItem(titel: String, imageName: String) -> UITabBarItem {
        let filledImageName = "\(imageName)_filled"
        return UITabBarItem(title: titel, image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: filledImageName)?.withRenderingMode(.alwaysOriginal))
    }
}
