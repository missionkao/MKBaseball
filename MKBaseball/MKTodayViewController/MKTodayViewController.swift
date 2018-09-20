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
    case todayGame = 0, playerChange
    
    func headerView() -> UIView {
        let view = MKContainerView(frame: .zero)
        view.backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.sizeToFit()
        titleLabel.text = (self == .todayGame) ? "今日賽事" : "近三日球員異動"
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }
    
    func cellReuseIdentifier() -> String {
        switch self {
        case .todayGame: return "MKTodayGameTableViewCell"
        case .playerChange: return "MKTodayPlayerChangeTableViewCell"
        }
    }
}

class MKTodayViewController: UIViewController {
    
    private var viewModel: MKTodayViewModel
    private let refreshControl = UIRefreshControl()
    
    required init(viewModel: MKTodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(loadingView)
        view.addSubview(tableView)
        refreshControl.tintColor = UIColor.gray
        
        tableView.addSubview(refreshControl)
        
        setupConstraints()
        
        loadingView.startLoading(disappear: tableView)
        viewModel.fetchTodayGame()
    }
    
    private lazy var loadingView: MKLoadingView = {
        let view = MKLoadingView()
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.dataSource = self
        view.delegate = self
        view.register(MKGameTableViewCell.self, forCellReuseIdentifier: MKTodayViewControllerTableViewSectionType.todayGame.cellReuseIdentifier())
        view.register(MKTodayChangeTableViewCell.self, forCellReuseIdentifier: MKTodayViewControllerTableViewSectionType.playerChange.cellReuseIdentifier())
        return view
    }()
}

extension MKTodayViewController: MKTodayViewModelDelegate {
    func viewModel(_ viewModel: MKTodayViewModel, didChangeLoadingStatus status: MKViewMode) {
        DispatchQueue.main.sync { [unowned self] in
            self.refreshControl.endRefreshing()
            if status == .error {
                self.loadingView.loadingTimeout(disappear: tableView)
            } else if status == .complete {
                self.loadingView.shouldShowView(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
}

extension MKTodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = section == 0 ? viewModel.competitions.count : viewModel.changes.count
        return count == 0 ? 1 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = MKTodayViewControllerTableViewSectionType(rawValue: indexPath.section)!.cellReuseIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MKTableViewCellProtocol
        
        let count = indexPath.section == 0 ? viewModel.competitions.count : viewModel.changes.count
        if count == 0 {
            cell.applyCellViewModel(nil)
        } else {
            let model: MKTableViewCellViewModelProtocol = indexPath.section == 0 ? viewModel.competitions[indexPath.row] : viewModel.changes[indexPath.row]
            cell.applyCellViewModel(model)
        }
        
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || viewModel.changes.count == 0 {
            return 100
        }
        return 48
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            viewModel.fetchTodayGame()
        }
    }
}

extension MKTodayViewController: MKLoadingViewDelegate {
    func loadingView(_ view: MKLoadingView, didClickRetryButton button: UIButton) {
        viewModel.fetchTodayGame()
    }
}

private extension MKTodayViewController {
    func setupConstraints() {
        loadingView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-48)
        }
        
        tableView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}
