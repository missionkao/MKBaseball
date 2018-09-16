//
//  MKNewsTableViewCell.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/29.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import Kingfisher

struct MKNewsTableViewCellViewModel {
    let image: String?
    let title: String?
    let date: String?
    let link: String?
}

class MKNewsTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(newsImageView)
        contentView.addSubview(rightView)
        rightView.addSubview(titleLabel)
        rightView.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    func applyCellViewModel(_ cellViewModel: MKNewsTableViewCellViewModel) {
        if let image = cellViewModel.image {
            newsImageView.kf.setImage(with: URL(string: image))
        }
        
        titleLabel.text = cellViewModel.title
        dateLabel.text = cellViewModel.date
    }
    
    private lazy var newsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.lightGray
        return view
    }()
}

private extension MKNewsTableViewCell {
    func setupConstraints() {
        newsImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(142)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(newsImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(88)
            make.right.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
}
