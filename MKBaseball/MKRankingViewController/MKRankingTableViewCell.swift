//
//  MKRankingTableViewCell.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/26.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKRankingTableViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    fileprivate func setupLabels() -> ([UILabel], [CGFloat]) {
        return ([UILabel](), [CGFloat]())
    }
    
    fileprivate func commonLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = UIColor.cpblBlue
        view.textAlignment = .center
        view.text = "test"
        return view
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        let labelTuple = setupLabels()
        let labels = labelTuple.0
        let widths = labelTuple.1
        
        var tuples = [(UILabel, CGFloat)]()
        for (index, label) in labels.enumerated() {
            tuples.append((label, widths[index]))
        }
        
        for t in tuples {
            stackView.addArrangedSubview(t.0)
            t.0.snp.makeConstraints({ (make) in
                make.width.equalToSuperview().multipliedBy(t.1)
            })
        }
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.spacing = 0
        return view
    }()
}

class MKRankingTableViewRankCell: MKRankingTableViewCell {
    
    override fileprivate func setupLabels() -> ([UILabel], [CGFloat]) {
        let labels = [rankLabel, teamLabel, gameLabel, gradeLabel, averageLabel, diffLabel]
        let widths = MKRankingTableViewSectionType.rank.labelWidthMultiplies()
        
        return (labels, widths)
    }
    
    //排名, 球隊, 出賽, 勝-和-敗, 勝率, 勝差
    private lazy var rankLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var teamLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var gameLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var gradeLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var averageLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var diffLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
}

class MKRankingTableViewBetweenCell: MKRankingTableViewCell {
    override fileprivate func setupLabels() -> ([UILabel], [CGFloat]) {
        let labels = [teamLabel, firstLabel, secondLabel, thirdLabel, fourthLabel]
        let widths = MKRankingTableViewSectionType.between.labelWidthMultiplies()
        
        return (labels, widths)
    }
    
    //Lamigo, 中信兄弟, 富邦, 統一
    private lazy var teamLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var firstLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var secondLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var thirdLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var fourthLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
}

class MKRankingTableViewTeamCell: MKRankingTableViewCell {
    override fileprivate func setupLabels() -> ([UILabel], [CGFloat]) {
        let labels = [teamLabel, goalLabel, loseLabel, hrLabel, hitLabel, eraLabel]
        let widths = MKRankingTableViewSectionType.team.labelWidthMultiplies()
        
        return (labels, widths)
    }
    
    //得分, 失分, 全壘打, 打擊率, 防禦率
    private lazy var teamLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var goalLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var loseLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var hrLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var hitLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var eraLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
}
