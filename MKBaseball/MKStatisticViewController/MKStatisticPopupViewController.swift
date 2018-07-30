//
//  MKStatisticPopupViewController.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/29.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import PopupController

class MKStatisticPopupViewController: UIViewController {
    
    private let cellReuseIdentifier = "MKStatisticPopupTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.rowHeight = 56
        view.dataSource = self
        view.delegate = self
        view.register(MKStatisticTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return view
    }()
    
}

extension MKStatisticPopupViewController: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 128)
        
        return size
    }
}

extension MKStatisticPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
}

extension MKStatisticPopupViewController: UITableViewDelegate {
}

private extension MKStatisticPopupViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
}
