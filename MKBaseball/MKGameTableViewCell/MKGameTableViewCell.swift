//
//  MKGameTableViewCell.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/28.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKGameTableViewCell: UITableViewCell {

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
    
    func applyCellViewModel(viewModel: MKGameTableViewCellViewModel) {
        leftImageView.image = UIImage(named: viewModel.awayTeam.logoImageName())
        leftLabel.text = viewModel.awayScore
        rightImageView.image = UIImage(named: viewModel.homeTeam.logoImageName())
        rightLabel.text = viewModel.homeScore
        locationLabel.text = viewModel.location
        timeLabel.text = viewModel.currentState
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
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let view = topGeneralLabel()
        return view
    }()
    
    private lazy var middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var leftImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var leftLabel: UILabel = {
        let view = middleGeneralLabel()
        return view
    }()
    
    private lazy var vsLabel: UILabel = {
        let view = middleGeneralLabel()
        view.text = "VS"
        return view
    }()
    
    private lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var rightLabel: UILabel = {
        let view = middleGeneralLabel()
        return view
    }()
}

private extension MKGameTableViewCell {
    func setupConstraints() {
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        middleView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(24)
        }
        
        vsLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImageView.snp.left).offset(-24)
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
    }
    
    func topGeneralLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.cpblBlue
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .center
        view.sizeToFit()
        return view
    }
    
    func middleGeneralLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.cpblBlue
        view.font = UIFont.systemFont(ofSize: 36)
        view.textAlignment = .center
        view.sizeToFit()
        return view
    }
}
