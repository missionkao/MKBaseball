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
    fileprivate var isReachingEnd = false
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
        view.backgroundColor = UIColor.white
        view.addSubview(headerView)
        view.addSubview(loadingView)
        view.addSubview(tableView)
        
        setupConstraints()
        
        loadingView.startLoading(disappear: tableView)
        viewModel.fetchNews()
        
        rotateFooterImage(options: .curveEaseIn)
    }
    
    private lazy var headerView: MKSegmentedControlHeaderView = {
        let view = MKSegmentedControlHeaderView(items: ["職棒消息", "職棒影片"])
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
        view.alpha = 0
        view.tableFooterView = footerView()
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.register(MKNewsTableViewCell.self, forCellReuseIdentifier: newsCellReuseIdentifier)
        return view
    }()
    
    private lazy var indicatorImageView: UIImageView! = {
        let image = UIImage(named: "loading_circle")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
}

extension MKNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewMode == .news ? viewModel.newsModels.count : viewModel.videoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellReuseIdentifier, for: indexPath) as! MKNewsTableViewCell
        let cellViewModel = viewMode == .news ? viewModel.newsModels[indexPath.row] : viewModel.videoModels[indexPath.row]
        cell.applyCellViewModel(cellViewModel)
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
        
        let link = (viewMode == .news) ? viewModel.newsModels[indexPath.row].link : viewModel.videoModels[indexPath.row].link
        guard let l = link, let url = URL(string: l) else {
            return
        }
        
        PopupController
            .create(self)
            .customize(popupOptions)
            .show(MKNewsPopupViewController(url: url))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        // 偵測是否已經滑到最底部, 並且利用 isReachingEnd 判斷在 false -> true 時, 才需要 call fetch
        if distanceFromBottom < height && tableView.alpha == 1 {
            if isReachingEnd == false {
                viewMode == .news ? viewModel.fetchNews() : viewModel.fetchVideo()
            }
            isReachingEnd = true
        } else {
            isReachingEnd = false
        }
    }
}

extension MKNewsViewController: MKNewsViewModelDelegate {
    func viewModel(_ viewModel: MKNewsViewModel, didChangeLoadingStatus status: MKViewMode) {
        DispatchQueue.main.sync { [unowned self] in
            if status == .error {
                self.loadingView.loadingTimeout(disappear: tableView)
                return
            }
            self.loadingView.shouldShowView(self.tableView)
            self.tableView.reloadData()
        }
    }
}

extension MKNewsViewController: MKSegmentedControlHeaderViewDelegate {
    func headerView(_ headerView: MKSegmentedControlHeaderView, didSelectSegmentControl atIndex: Int) {
        viewMode = MKNewsViewMode(segmentControlIndex: atIndex)
        // 還沒載過資料, 需要重新 fetch
        if hasNotFetchData() == true {
            self.tableView.alpha = 0
            self.loadingView.startLoading(disappear: tableView)
            viewMode == .news ? viewModel.fetchNews() : viewModel.fetchVideo()
            return
        }
        tableView.reloadData()
    }
}

extension MKNewsViewController: MKLoadingViewDelegate {
    func loadingView(_ view: MKLoadingView, didClickRetryButton button: UIButton) {
        viewMode == .news ? viewModel.fetchNews() : viewModel.fetchVideo()
    }
}

private extension MKNewsViewController {
    func setupConstraints() {
        headerView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalToSuperview()
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
    
    func hasNotFetchData() -> Bool {
        return (viewMode == .video && viewModel.hasFetchedVideo == false) || (viewMode == .news && viewModel.hasFetchedNews == false)
    }
    
    func footerView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        view.backgroundColor = UIColor.white
        view.addSubview(indicatorImageView)
        indicatorImageView.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
            maker.width.height.equalTo(64)
        }
        return view
    }
    
    func rotateFooterImage(options: UIViewAnimationOptions) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: options, animations: {
            self.indicatorImageView.transform = self.indicatorImageView.transform.rotated(by: CGFloat(-Double.pi / 2))
        }) { (finished) in
            if finished == true {
                self.rotateFooterImage(options: .curveLinear)
            }
        }
    }
}
