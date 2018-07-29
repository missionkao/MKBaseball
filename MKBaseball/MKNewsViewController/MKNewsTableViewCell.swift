//
//  MKNewsTableViewCell.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/29.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKNewsTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(rightView)
        rightView.addSubview(titleLabel)
        rightView.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private lazy var newsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        // NOTE: This is synchronously on main thread
        let url = URL(string: "http://cpbl-elta.cdn.hinet.net/upload/news/18282.jpg")
        if let data = try? Data(contentsOf: url!) {
            view.image = UIImage(data: data)
        }
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
        view.text = "詹子賢轟雙響砲 帶領中信兄弟擊退富邦"
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "2018.07.28"
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
            make.height.equalTo(88)
            make.width.equalTo(156)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(newsImageView.snp.right).offset(16)
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
