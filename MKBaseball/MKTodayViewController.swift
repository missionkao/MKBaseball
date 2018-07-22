//
//  MKTodayViewController.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/21.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import SnapKit

enum MKTodayViewControllerTableViewSectionType: Int {
    case todayGame = 0, memberChange
    
    func headerView() -> UIView {
        let view = MKContainerView.init(frame: .zero)
        view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.sizeToFit()
        titleLabel.text = (self == .todayGame) ? "今日賽事" : "球員異動"
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }
    
    func cellView() -> UITableViewCell {
        switch self {
        case .todayGame:
            return MKTodayGameTableViewCell(style: .default, reuseIdentifier: nil)
        case .memberChange:
            return MKTodayChangeTableViewCell(style: .default, reuseIdentifier: nil)
        }
    }
}

class MKTodayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
}

extension MKTodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MKTodayViewControllerTableViewSectionType.init(rawValue: indexPath.section)!.cellView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MKTodayViewControllerTableViewSectionType.init(rawValue: section)?.headerView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
}

extension MKTodayViewController: UITableViewDelegate {
    
}

private extension MKTodayViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(56 + 16)
            } else {
                make.top.equalToSuperview().offset(56 + 16)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}
