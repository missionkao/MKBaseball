//
//  MKNewsViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/6.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation

protocol MKNewsViewModelDelegate: class {
    func viewModel(_ viewModel: MKNewsViewModel, didChangeViewMode: MKViewMode)
}

class MKNewsViewModel {
    weak var delegate: MKNewsViewModelDelegate?
    
    func fetchNews(page: Int = 0) {
        
        MKAPIClinet.fetchHTMLFrom(url: "url", success: { [unowned self] (html) in
            
            self.delegate?.viewModel(self, didChangeViewMode: .complete)
        }) { (error) in
        }
    }
    
    
}
