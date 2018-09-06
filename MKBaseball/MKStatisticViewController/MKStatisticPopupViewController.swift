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
    private var viewModel: MKStatisticPopupViewModel!
    
    required init(viewModel: MKStatisticPopupViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        setupConstraints()
        
        self.viewModel.fetchStatistic()
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
        view.register(MKStatisticPopupTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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
        return self.viewModel.statisticTuples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MKStatisticPopupTableViewCell
        cell.applyCellViewModel(tuple: self.viewModel.statisticTuples[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView()
    }
}

extension MKStatisticPopupViewController: UITableViewDelegate {
}

extension MKStatisticPopupViewController: MKStatisticPopupViewModelDelegate {
    func viewModel(_ viewModel: MKStatisticPopupViewModel, didChangeViewMode: MKViewMode) {
        if didChangeViewMode == .loading {
            return
        }
        DispatchQueue.main.sync { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

private extension MKStatisticPopupViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func sectionHeaderView() -> UIView {
        let view = MKContainerView()
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.cpblBlue
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        
        var attributes = [NSAttributedStringKey:Any]()
        attributes[.font] = UIFont.systemFont(ofSize: 24)
        let title = NSAttributedString(string: self.viewModel.type.uppercased(), attributes: attributes)
        attributes[.font] = UIFont.systemFont(ofSize: 10)
        let subtitle = NSAttributedString(string: "  \(self.viewModel.type.localizedDescription())", attributes: attributes)
        let string = NSMutableAttributedString(attributedString: title)
        string.append(subtitle)
        
        label.attributedText = string
        
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }
}
