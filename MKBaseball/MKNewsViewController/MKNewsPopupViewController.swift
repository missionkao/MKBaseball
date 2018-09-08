//
//  MKNewsPopupViewController.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/8.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import PopupController
import WebKit

class MKNewsPopupViewController: UIViewController {
    let urlRequest: URLRequest
    
    required init(url: URL) {
        self.urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(webView)
        setupConstraints()
        
        webView.load(urlRequest)
    }
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.navigationDelegate = self
        view.backgroundColor = UIColor.white
        return view
    }()
}

extension MKNewsPopupViewController: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 128)
        
        return size
    }
}

extension MKNewsPopupViewController: WKNavigationDelegate {
}

private extension MKNewsPopupViewController {
    func setupConstraints() {
        webView.snp.makeConstraints { (maker) in
            maker.top.bottom.left.right.equalToSuperview()
        }
    }
}
