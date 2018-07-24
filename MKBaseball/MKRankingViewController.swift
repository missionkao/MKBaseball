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
    
    //戰績排名
    //排名, 球隊, 出賽, 勝-和-敗, 勝率, 勝差
    
    //對戰成績
    //Lamigo, 中信兄弟, 富邦, 統一
    
    //團隊成績
    //得分, 失分, 全壘打, 打擊率, 防禦率
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
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var labelTexts = [String]()
        if section == 0 {
            labelTexts = ["排名", "球隊", "出賽", "勝-和-敗", "勝率", "勝差"]
        } else if section == 1 {
            labelTexts = ["Lamigo", "中信兄弟", "富邦", "統一"]
        } else {
            labelTexts = ["得分", "失分", "全壘打", "打擊率", "防禦率"]
        }
        return MKRankingTableViewSectionType(rawValue: section)?.sectionHeaderView(labelTexts: labelTexts)
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
