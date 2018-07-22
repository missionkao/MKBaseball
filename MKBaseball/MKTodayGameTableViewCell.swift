//
//  MKTodayGameTableViewCell.swift
//  MKBaseball
//
//  Created by Mission on 2018/7/22.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import SnapKit

class MKTodayGameTableViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        contentView.addSubview(topView)
        topView.addArrangedSubview(locationLabel)
        topView.addArrangedSubview(timeLabel)
        
        contentView.addSubview(middleView)
        middleView.addSubview(leftImageView)
        middleView.addSubview(leftLabel)
        middleView.addSubview(vsLabel)
        middleView.addSubview(rightLabel)
        middleView.addSubview(rightImageView)
        
        setupConstraints()
    }
    
    private lazy var topView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    private lazy var locationLabel: UILabel = {
        let view = topGeneralLabel()
        view.text = "新莊棒球場"
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let view = topGeneralLabel()
        view.text = "17:05"
        return view
    }()
    
    private lazy var middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var leftImageView: UIImageView = {
        let view = UIImageView.init(image: UIImage(named: "Score_M_logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftLabel: UILabel = {
        let view = middleGeneralLabel()
        view.text = "0"
        return view
    }()
    
    private lazy var vsLabel: UILabel = {
        let view = middleGeneralLabel()
        view.text = "VS"
        return view
    }()
    
    private lazy var rightImageView: UIImageView = {
        let view = UIImageView.init(image: UIImage(named: "Score_G_logo"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightLabel: UILabel = {
        let view = middleGeneralLabel()
        view.text = "10"
        return view
    }()

}

private extension MKTodayGameTableViewCell {
    func setupConstraints() {
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(32)
            make.centerX.equalToSuperview()
        }
        
        middleView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(88)
        }
        
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(16)
        }
        
        vsLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImageView.snp.left).offset(-16)
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
    }
    
    func topGeneralLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.cpblBlue
        view.font = UIFont.systemFont(ofSize: 16)
        view.textAlignment = .center
        view.sizeToFit()
        return view
    }
    
    func middleGeneralLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.cpblBlue
        view.font = UIFont.systemFont(ofSize: 32)
        view.textAlignment = .center
        view.sizeToFit()
        return view
    }
}
