//
//  MKVideoTableViewCell.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/29.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

class MKVideoTableViewCell: UITableViewCell {

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
    
    private lazy var videoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        // NOTE: This is synchronously on main thread
        // WIP: use Kingfisher to cashe image
        let url = URL(string: "https://img.youtube.com/vi/uzt7711Zsr4/hqdefault.jpg")
        if let data = try? Data(contentsOf: url!) {
            view.image = UIImage(data: data)
        }
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        return view
    }()
    
    private lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        view.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor.white
        view.text = "07/28 兄弟 vs 富邦 九局下，李振昌成功擊敗旅美邦，霸氣飆出再見三振，順利收下第一次SV"
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
