//
//  MKTodayChangeTableViewCell.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/22.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKTodayChangeTableViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(teamLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(reasonLabel)
        
        setupConstraints()
    }
    
    private lazy var dateLabel: UILabel = {
        let view = commonLabel()
        view.text = "2018/08/06"
        return view
    }()
    
    private lazy var teamLabel: UILabel = {
        let view = commonLabel()
        view.text = TEAM_NAME_LION
        view.textAlignment = .center
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = commonLabel()
        view.text = "馬丁尼茲"
        view.textAlignment = .center
        return view
    }()
    
    private lazy var reasonLabel: UILabel = {
        let view = commonLabel()
        view.text = "升一軍"
        view.textAlignment = .center
        return view
    }()

}

private extension MKTodayChangeTableViewCell {
    func setupConstraints() {
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        teamLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(teamLabel.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        reasonLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func commonLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.cpblBlue
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        return view
    }
}
