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
        contentView.addSubview(noPlayerChangeLabel)
        
        setupConstraints()
    }
    
    func applyPlayerChangeModel(model: MKPlayerChangeModel?) {
        if let model = model {
            shouldSwitchToNoPlayerChangeView(false)
            dateLabel.text = model.date
            teamLabel.text = model.team.rawValue
            nameLabel.text = model.player
            reasonLabel.text = model.reason
        } else {
            shouldSwitchToNoPlayerChangeView(true)
        }
    }
    
    private lazy var dateLabel: UILabel = {
        let view = commonLabel()
        view.textAlignment = .left
        return view
    }()
    
    private lazy var teamLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var reasonLabel: UILabel = {
        let view = commonLabel()
        return view
    }()
    
    private lazy var noPlayerChangeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 24)
        view.textColor = UIColor.lightGray
        var attribute = [NSAttributedStringKey:Any]()
        attribute[.kern] = 5.0
        view.attributedText = NSAttributedString(string: "近三日無球員異動", attributes: attribute)
        return view
    }()
}

private extension MKTodayChangeTableViewCell {
    func setupConstraints() {
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        
        teamLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
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
        
        noPlayerChangeLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func commonLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.cpblBlue
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .center
        return view
    }
    
    func shouldSwitchToNoPlayerChangeView(_ should: Bool) {
        dateLabel.alpha = should ? 0 : 1
        teamLabel.alpha = should ? 0 : 1
        nameLabel.alpha = should ? 0 : 1
        reasonLabel.alpha = should ? 0 : 1
        noPlayerChangeLabel.alpha = should ? 1 : 0
    }
}
