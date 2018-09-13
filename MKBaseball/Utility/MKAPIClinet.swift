//
//  MKAPIClinet.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/31.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation

enum FetchingHTMLError: Error {
    case invalidURLString
    case emptyHTML
    case encodingError
    case responseError
}

class MKAPIClinet {
    
    @discardableResult
    static func fetchHTMLFrom(url: String, success: @escaping (_: String) -> Void, failure: @escaping (_: Error) -> Void) -> URLSessionDataTask? {
        guard let urlFromString = URL(string: url) else {
            failure(FetchingHTMLError.invalidURLString)
            return nil
        }
        
        let configiguration = URLSessionConfiguration.default
        configiguration.timeoutIntervalForRequest = 5
        
        let task = URLSession(configuration: configiguration).dataTask(with: urlFromString) { (data, response, error) in
            if let e = error as NSError? {
                if e.code == NSURLErrorTimedOut {
                    self.fetchHTMLFrom(url: url, success: success, failure: failure)
                } else {
                    failure(FetchingHTMLError.responseError)
                }
                return
            }
            guard let data = data else {
                failure(FetchingHTMLError.emptyHTML)
                return
            }
            guard let html = String(data: data, encoding: String.Encoding.utf8) else {
                failure(FetchingHTMLError.encodingError)
                return
            }
            success(html)
        }
        task.resume()
        return task
    }
}
