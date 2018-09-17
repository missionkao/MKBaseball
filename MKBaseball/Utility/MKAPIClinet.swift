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
    case cancelled
}

class MKAPIClinet {
    
    @discardableResult
    static func fetchHTMLFrom(url: String, success: @escaping (_: String) -> Void, failure: @escaping (_: FetchingHTMLError) -> Void) -> URLSessionDataTask? {
        guard let urlFromString = URL(string: url) else {
            failure(.invalidURLString)
            return nil
        }
        
        let configiguration = URLSessionConfiguration.default
        configiguration.timeoutIntervalForRequest = 5
        
        let task = URLSession(configuration: configiguration).dataTask(with: urlFromString) { (data, response, error) in
            if let e = error as NSError? {
                if e.code == NSURLErrorTimedOut {
                    self.fetchHTMLFrom(url: url, success: success, failure: failure)
                } else if e.code == NSURLErrorCancelled {
                    failure(.cancelled)
                } else {
                    failure(.responseError)
                }
                return
            }
            guard let data = data else {
                failure(.emptyHTML)
                return
            }
            guard let html = String(data: data, encoding: String.Encoding.utf8) else {
                failure(.encodingError)
                return
            }
            success(html)
        }
        task.resume()
        return task
    }
}
