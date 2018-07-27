//
//  MKScheduleViewController.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/27.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKScheduleViewController: UIViewController {
    
    private let cellReuseIdentifier = "MKScheduleTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        view.addSubview(stackView)
        view.addSubview(tableView)
        
        stackView.addArrangedSubview(monthLabel)
        
        setupConstraints()
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 0
        return view
    }()
    
    private lazy var monthLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "test"
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.rowHeight = 44
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return view
    }()
}

extension MKScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}

extension MKScheduleViewController: UITableViewDelegate {
}

private extension MKScheduleViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(56 + 16)
            } else {
                make.top.equalToSuperview().offset(56 + 16)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
