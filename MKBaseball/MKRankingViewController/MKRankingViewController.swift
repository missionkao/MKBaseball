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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.dataSource = self
        view.delegate = self
        
        for type in sectionTypes {
            view.register(UITableViewCell.self, forCellReuseIdentifier: type.cellReuseIdentifier())
        }
        
        return view
    }()

}

extension MKRankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = MKRankingTableViewSectionType(rawValue: indexPath.section)!.cellReuseIdentifier()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "test"
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
            labelTexts = ["Lamigo", "中信兄弟", "富邦", "統一"]
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
}

private extension MKRankingViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(56 + 16)
            } else {
                make.top.equalToSuperview().offset(56 + 16)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}
