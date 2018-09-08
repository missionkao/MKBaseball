//
//  MKNewsViewController.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/28.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import PopupController

fileprivate let newsCellReuseIdentifier = "MKNewsTableViewCell"

enum MKNewsViewMode: Int {
    case news = 0, video
    
    init(segmentControlIndex: Int) {
        self = segmentControlIndex == 0 ? .news : .video
    }
}

class MKNewsViewController: UIViewController {

    fileprivate var viewModel: MKNewsViewModel!
    
    private var viewMode: MKNewsViewMode = .news
    
    required init(viewModel: MKNewsViewModel) {
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
        view.addSubview(tableView)
        
        setupConstraints()
        
        viewModel.fetchNews()
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
        return view
    }()
}

extension MKNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewMode == .news {
            return viewModel.newsModels.count
        }
        return viewModel.videoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellReuseIdentifier, for: indexPath) as! MKNewsTableViewCell
        
        if viewMode == .news {
            cell.applyCellViewModel(viewModel.newsModels[indexPath.row])
        } else {
            cell.applyCellViewModel(viewModel.videoModels[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
}

extension MKNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popupOptions: [PopupCustomOption] = [
            .layout(.center),
            .animation(.slideUp),
            .backgroundStyle(.blackFilter(alpha: 0.1)),
            .dismissWhenTaps(true),
            .scrollable(true)
        ]
        
        guard let link = viewModel.newsModels[indexPath.row].link, let url = URL(string: link) else {
            return
        }
        
        PopupController
            .create(self)
            .customize(popupOptions)
            .show(MKNewsPopupViewController(url: url))
    }
}

extension MKNewsViewController: MKNewsViewModelDelegate {
    func viewModel(_ viewModel: MKNewsViewModel, didChangeViewMode: MKViewMode) {
        DispatchQueue.main.sync { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

extension MKNewsViewController: MKSegmentedControlHeaderViewDelegate {
    func headerView(_ headerView: MKSegmentedControlHeaderView, didSelectSegmentControl atIndex: Int) {
        viewMode = MKNewsViewMode(segmentControlIndex: atIndex)
        if viewMode == .video && viewModel.hasfetchedVideo == false {
            viewModel.fetchVideo()
        }
        tableView.reloadData()
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
