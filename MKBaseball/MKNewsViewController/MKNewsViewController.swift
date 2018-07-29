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
            tableView.backgroundColor = (viewMode == .news ? UIColor.white : UIColor.black)
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
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.register(MKNewsTableViewCell.self, forCellReuseIdentifier: newsCellReuseIdentifier)
        view.register(MKVideoTableViewCell.self, forCellReuseIdentifier: videoCellReuseIdentifier)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewMode == .news {
            return 120
        }
        return 212
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
