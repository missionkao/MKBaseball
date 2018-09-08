//
//  MKVideoTableViewCell.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/29.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

struct MKVideoTableViewCellViewModel {
    let image: String?
    let title: String?
    let date: String?
    let link: String?
}

class MKVideoTableViewCell: UITableViewCell {
    
    var link: String?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.addSubview(videoImageView)
        contentView.addSubview(titleTextView)
        
        setupConstraints()
    }
    
    func applyCellViewModel(_ model: MKVideoTableViewCellViewModel) {
        if let image = model.image, let url = URL(string: image), let data = try? Data(contentsOf: url) {
            videoImageView.image = UIImage(data: data)
        }
        titleTextView.text = model.title
        link = model.link
    }
    
    private lazy var videoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        view.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor.white
        view.isEditable = false
        view.isScrollEnabled = false
        return view
    }()
}

private extension MKVideoTableViewCell {
    func setupConstraints() {
        videoImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        titleTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
