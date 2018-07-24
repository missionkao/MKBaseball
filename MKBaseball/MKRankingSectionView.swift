//
//  MKRankingSectionView.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/24.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKRankingSectionView: MKContainerView {
    
    private let sectionType: MKRankingTableViewSectionType
    private let labelTexts: [String]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(sectionType: MKRankingTableViewSectionType, labelTexts: [String]) {
        self.sectionType = sectionType
        self.labelTexts = labelTexts
        super.init(frame: .zero)
        
        backgroundColor = UIColor.white
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        switch self.sectionType {
        case .rank:
            setupRankSectionView()
        case .between:
            setupBetweenSectionView()
        case .team:
            setupTeamSectionView()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.spacing = 0
        return view
    }()
    
    //戰績排名
    //排名, 球隊, 出賽, 勝-和-敗, 勝率, 勝差
    
    private lazy var rankLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[0]
        return view
    }()
    
    private lazy var teamLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[1]
        return view
    }()
    
    private lazy var gameLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[2]
        return view
    }()
    
    private lazy var gradeLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[3]
        return view
    }()
    
    private lazy var averageLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[4]
        return view
    }()
    
    private lazy var diffLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[5]
        return view
    }()
    
    //對戰成績
    //Lamigo, 中信兄弟, 富邦, 統一
    private lazy var firstLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[0]
        return view
    }()
    
    private lazy var secondLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[1]
        return view
    }()
    
    private lazy var thirdLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[2]
        return view
    }()
    
    private lazy var fourthLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[3]
        return view
    }()
    
    //團隊成績
    //得分, 失分, 全壘打, 打擊率, 防禦率
    private lazy var goalLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[0]
        return view
    }()
    
    private lazy var loseLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[1]
        return view
    }()
    
    private lazy var hrLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[2]
        return view
    }()
    
    private lazy var hitLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[3]
        return view
    }()
    
    private lazy var eraLabel: UILabel = {
        let view = commonLabel()
        view.text = labelTexts[4]
        return view
    }()
}

private extension MKRankingSectionView {
    func setupRankSectionView() {
        var tuples = [(UILabel, CGFloat)]()
        tuples.append((rankLabel, 0.1))
        tuples.append((teamLabel, 0.3))
        tuples.append((gameLabel, 0.1))
        tuples.append((gradeLabel, 0.25))
        tuples.append((averageLabel, 0.15))
        tuples.append((diffLabel, 0.1))
        
        setupView(tuples: tuples)
    }
    
    func setupBetweenSectionView() {
        var tuples = [(UILabel, CGFloat)]()
        tuples.append((firstLabel, 0.25))
        tuples.append((secondLabel, 0.25))
        tuples.append((thirdLabel, 0.25))
        tuples.append((fourthLabel, 0.25))
        
        setupView(tuples: tuples)
    }
    
    func setupTeamSectionView() {
        var tuples = [(UILabel, CGFloat)]()
        tuples.append((goalLabel, 0.2))
        tuples.append((loseLabel, 0.2))
        tuples.append((hrLabel, 0.2))
        tuples.append((hitLabel, 0.2))
        tuples.append((eraLabel, 0.2))
        
        setupView(tuples: tuples)
    }
    
    func setupView(tuples: [(UILabel, CGFloat)]) {
        for t in tuples {
            stackView.addArrangedSubview(t.0)
            t.0.snp.makeConstraints({ (make) in
                make.width.equalToSuperview().multipliedBy(t.1)
            })
        }
    }
    
    func commonLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.cpblBlue
        view.textAlignment = .center
        return view
    }
}
