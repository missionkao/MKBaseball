//
//  MKStatisticPopupTableViewCell.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/30.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKStatisticPopupTableViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(rankLabel)
        contentView.addSubview(playerLabel)
        contentView.addSubview(teamLabel)
        contentView.addSubview(valueLabel)
        
        setupConstraints()
    }
    
    private lazy var rankLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = UIColor.black
        view.text = "1"
        view.textAlignment = .center
        return view
    }()
    
    private lazy var playerLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = UIColor.black
        view.text = "胡金龍"
        return view
    }()
    
    private lazy var teamLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = UIColor.lightGray
        view.text = CPBLTeam.guardians.rawValue
        return view
    }()
    
    private lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.textColor = UIColor.black
        view.textAlignment = .right
        view.text = "0.367"
        return view
    }()
}

private extension MKStatisticPopupTableViewCell {
    func setupConstraints() {
        rankLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
        }
        
        playerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rankLabel.snp.right).offset(16)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(24)
        }
        
        teamLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rankLabel.snp.right).offset(16)
            make.top.equalTo(playerLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
    }
}
