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
        
        setupView()
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
    func setupView() {
        var labels = [UILabel]()
        switch sectionType {
        case .rank:
            labels = [rankLabel, teamLabel, gameLabel, gradeLabel, averageLabel, diffLabel]
        case .between:
            labels = [commonLabel(), firstLabel, secondLabel, thirdLabel, fourthLabel]
        case .team:
            labels = [commonLabel(), goalLabel, loseLabel, hrLabel, hitLabel, eraLabel]
        }
        
        let widths = sectionType.labelWidthMultiplies()
        
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
