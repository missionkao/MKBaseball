//
//  MKStatisticViewController.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/28.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import PopupController

fileprivate enum MKStatisticViewMode: Int {
    case hitter = 0, pitcher
}

class MKStatisticViewController: UIViewController {
    
    private let cellReuseIdentifier = "MKStatisticTableViewCell"
    private var viewModel: MKStatisticViewModel!
    private var viewMode: MKStatisticViewMode = .hitter {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    required init(viewModel: MKStatisticViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        view.addSubview(headerView)
        view.addSubview(loadingView)
        view.addSubview(tableView)
        
        setupConstraints()
        
        loadingView.startLoading(disappear: tableView)
        viewModel.fetchStatistic()
    }
    
    private lazy var headerView: MKSegmentedControlHeaderView = {
        let view = MKSegmentedControlHeaderView(items: ["打擊數據", "投手數據"])
        view.delegate = self
        return view
    }()
    
    private lazy var loadingView: MKLoadingView = {
        let view = MKLoadingView()
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
        view.rowHeight = 56
        view.dataSource = self
        view.delegate = self
        view.register(MKStatisticTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return view
    }()
}

extension MKStatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewMode == .hitter {
            return self.viewModel.hitTuples.count
        }
        
        return self.viewModel.pitchTuples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MKStatisticTableViewCell
        
        if viewMode == .hitter {
            cell.applyCellViewModel(tuple: self.viewModel.hitTuples[indexPath.row])
        } else {
            cell.applyCellViewModel(tuple: self.viewModel.pitchTuples[indexPath.row])
        }
        
        return cell
    }
}

extension MKStatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popupOptions: [PopupCustomOption] = [
            .layout(.center),
            .animation(.slideUp),
            .backgroundStyle(.blackFilter(alpha: 0.1)),
            .dismissWhenTaps(true),
            .scrollable(true)
        ]
        
        let type: MKStatisticType!
        if viewMode == .hitter {
            type = self.viewModel.hits[indexPath.row]
        } else {
            type = self.viewModel.pitchs[indexPath.row]
        }
        
        let popupViewModel = MKStatisticPopupViewModel(type: type)
        
        PopupController
            .create(self)
            .customize(popupOptions)
            .show(MKStatisticPopupViewController(viewModel: popupViewModel))
    }
}

extension MKStatisticViewController: MKStatisticViewModelDelegate {
    func viewModel(_ viewModel: MKStatisticViewModel, didChangeLoadingStatus status: MKViewMode) {
        DispatchQueue.main.sync { [unowned self] in
            if status == .error {
                self.loadingView.loadingTimeout(disappear: tableView)
            } else if status == .complete {
                self.loadingView.shouldShowView(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
}

extension MKStatisticViewController: MKLoadingViewDelegate {
    func loadingView(_ view: MKLoadingView, didClickRetryButton button: UIButton) {
        viewModel.fetchStatistic()
    }
}

extension MKStatisticViewController: MKSegmentedControlHeaderViewDelegate {
    func headerView(_ headerView: MKSegmentedControlHeaderView, didSelectSegmentControl atIndex: Int) {
        if atIndex == 0 {
            self.viewMode = .hitter
        } else {
            self.viewMode = .pitcher
        }
    }
}

private extension MKStatisticViewController {
    func setupConstraints() {
        headerView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(16)
            } else {
                make.top.equalToSuperview().offset(16)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        loadingView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerView.snp.bottom)
            maker.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-48)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
