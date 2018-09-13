//
//  MKLoadingView.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/9.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit

protocol MKLoadingViewDelegate : NSObjectProtocol {
    func loadingView(_ view: MKLoadingView, didClickRetryButton button: UIButton)
}

class MKLoadingView: UIView {
    weak var delegate: MKLoadingViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        self.addSubview(statusLabel)
        self.addSubview(retryButton)
        setupConstrains()
        
        retryButton.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
    }
    
    func startLoading(disappear view: UIView?) {
        self.alpha = 1
        view?.alpha = 0
        indicatorView.alpha = 1
        indicatorView.startAnimating()
        retryButton.alpha = 0
    }
    
    func shouldShowView(_ view: UIView) {
        if view.alpha == 0 {
            self.alpha = 0
            indicatorView.stopAnimating()
            view.alpha = 1
        }
    }
    
    func loadingTimeout(disappear view: UIView) {
        self.alpha = 1
        view.alpha = 0
        statusLabel.text = "無法取得資料, 請檢查網路後重試..."
        indicatorView.alpha = 0
        retryButton.alpha = 1
    }
    
    private func setupConstrains() {
        indicatorView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(statusLabel.snp.top).offset(-16)
        }
        
        statusLabel.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(statusLabel.snp.top).offset(-16)
            maker.width.equalTo(38)
            maker.height.equalTo(38)
        }
    }
    
    @objc private func retryAction() {
        self.startLoading(disappear: nil)
        delegate?.loadingView(self, didClickRetryButton: retryButton)
    }
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = UIColor.white
        view.sizeToFit()
        view.text = "讀取中..."
        return view
    }()
    
    private lazy var retryButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "retry")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.tintColor = UIColor.white
        view.backgroundColor = UIColor.clear
        return view
    }()
}
