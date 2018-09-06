//
//  MKRankingViewController.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/24.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

enum MKRankingTableViewSectionType: Int {
    case rank = 0, between, team
    
    func cellReuseIdentifier() -> String {
        switch self {
        case .rank: return "MKRankingRankTableViewCell"
        case .between: return "MKRankingBetweenTableViewCell"
        case .team: return "MKRankingTeamTableViewCell"
        }
    }
    
    func sectionHeaderView(labelTexts: [String]) -> UIView {
        return MKRankingSectionView(sectionType: self, labelTexts: labelTexts)
    }
    
    func sectionHeaderTitle() -> String {
        switch self {
        case .rank: return "戰績排名"
        case .between: return "對戰成績"
        case .team: return "團隊成績"
        }
    }
    
    func sectionHeaderTexts() -> [String] {
        switch self {
        case .rank: return ["排名", "球隊", "出賽", "勝-和-敗", "勝率", "勝差"]
        case .team: return ["得分", "失分", "全壘打", "打擊率", "防禦率"]
        default:
            return [String]()
        }
    }
    
    func cellClass() -> AnyClass {
        switch self {
        case .rank: return MKRankingTableViewRankCell.self
        case .between: return MKRankingTableViewBetweenCell.self
        case .team: return MKRankingTableViewTeamCell.self
        }
    }
    
    func labelWidthMultiplies() -> [CGFloat] {
        switch self {
        case .rank: return [0.1, 0.3, 0.1, 0.25, 0.15, 0.1]
        case .between: return [0.2, 0.2, 0.2, 0.2, 0.2]
        case .team: return [0.25, 0.15, 0.15, 0.15, 0.15, 0.15]
        }
    }
}

class MKRankingViewController: UIViewController {
    
    private let sectionTypes: [MKRankingTableViewSectionType] = [.rank, .between, .team]
    private var viewModel: MKRankingViewModel!
    private let refreshControl = UIRefreshControl()
    
    required init(viewModel: MKRankingViewModel) {
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
        refreshControl.tintColor = UIColor.white
        
        tableView.addSubview(refreshControl)
        
        setupConstraints()
        
        viewModel.fetchRanking()
    }
    
    private lazy var headerView: MKSegmentedControlHeaderView = {
        let view = MKSegmentedControlHeaderView(items: ["上半季", "下半季", "全年度"], defaultIndex: viewModel.defaultSelectedSegmentIndex)
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
        view.rowHeight = 44
        view.dataSource = self
        view.delegate = self
        
        for type in sectionTypes {
            view.register(type.cellClass(), forCellReuseIdentifier: type.cellReuseIdentifier())
        }
        
        return view
    }()
}

extension MKRankingViewController: MKRankingViewModelDelegate {
    func viewModel(_ viewModel: MKRankingViewModel, didChangeViewMode: MKViewMode) {
        DispatchQueue.main.sync { [unowned self] in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension MKRankingViewController: MKSegmentedControlHeaderViewDelegate {
    func headerView(_ headerView: MKSegmentedControlHeaderView, didSelectSegmentControl atIndex: Int) {
        viewModel.fetchRanking(seasonMode: MKSeasonMode(rawValue: atIndex)!)
    }
}

extension MKRankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.teamRanks.count
        } else if section == 1 {
            return viewModel.teamBetweens.count
        }
        return viewModel.teamGrades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = MKRankingTableViewSectionType(rawValue: indexPath.section)!.cellReuseIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        if indexPath.section == 0 {
            let rankCell = cell as! MKRankingTableViewRankCell
            rankCell.applyCellModel(model: viewModel.teamRanks[indexPath.row])
        } else if indexPath.section == 1 {
            let betweenCell = cell as! MKRankingTableViewBetweenCell
            betweenCell.applyCellModel(model: viewModel.teamBetweens[indexPath.row])
        } else {
            let gradeCell = cell as! MKRankingTableViewTeamCell
            gradeCell.applyCellModel(model: viewModel.teamGrades[indexPath.row])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var labelTexts = [String]()
        if section == 1 {
            let teams: [String] = viewModel.teamBetweens.compactMap { (model) -> String in
                return model.team.rawValue
            }
            labelTexts = teams.count == 0 ? ["--", "--", "--", "--"] : teams
        } else {
            labelTexts = MKRankingTableViewSectionType(rawValue: section)!.sectionHeaderTexts()
        }
        
        return MKRankingTableViewSectionType(rawValue: section)?.sectionHeaderView(labelTexts: labelTexts)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MKRankingViewController: UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            viewModel.fetchRanking(seasonMode: .bottom)
        }
    }
}

private extension MKRankingViewController {
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
