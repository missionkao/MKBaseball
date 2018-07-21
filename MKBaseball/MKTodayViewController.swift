//
//  MKTodayViewController.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/21.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import SnapKit

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
        view.rowHeight = UITableViewAutomaticDimension
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
}

extension MKTodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "test"
        return cell
    }
}

extension MKTodayViewController: UITableViewDelegate {
    
}

private extension MKTodayViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(56 + 8)
            } else {
                make.top.equalToSuperview().offset(56 + 8)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}
