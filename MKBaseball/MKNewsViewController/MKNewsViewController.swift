//
//  MKNewsViewController.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/28.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

enum MKNewsViewMode: Int {
    case news = 0, video
}

class MKNewsViewController: UIViewController {

    private let newsCellReuseIdentifier = "MKNewsTableViewCell"
    private let videoCellReuseIdentifier = "MKVideoTableViewCell"
    
    private var viewMode: MKNewsViewMode = .news {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private lazy var headerView: MKSegmentedControlHeaderView = {
        let view = MKSegmentedControlHeaderView(items: ["職棒消息", "職棒影片"])
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.rowHeight = 120
        view.dataSource = self
        view.delegate = self
        view.register(MKNewsTableViewCell.self, forCellReuseIdentifier: newsCellReuseIdentifier)
        view.register(UITableViewCell.self, forCellReuseIdentifier: videoCellReuseIdentifier)
        return view
    }()
}

extension MKNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewMode == .news {
            return tableView.dequeueReusableCell(withIdentifier: newsCellReuseIdentifier, for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: videoCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}

extension MKNewsViewController: UITableViewDelegate {
}

extension MKNewsViewController: MKSegmentedControlHeaderViewDelegate {
    func headerView(_ headerView: MKSegmentedControlHeaderView, didSelectSegmentControl atIndex: Int) {
        if atIndex == 0 {
            viewMode = .news
        } else {
            viewMode = .video
        }
    }
}

private extension MKNewsViewController {
    func setupConstraints() {
        headerView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(56 + 16)
            } else {
                make.top.equalToSuperview().offset(56 + 16)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
