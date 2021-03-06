//
//  MKNewsViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/6.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation
import Kanna

protocol MKNewsViewModelDelegate: NSObjectProtocol {
    func viewModel(_ viewModel: MKNewsViewModel, didChangeLoadingStatus status: MKViewMode)
}

class MKNewsViewModel {
    weak var delegate: MKNewsViewModelDelegate?
    
    private var fetchingTask: URLSessionDataTask?
    private var currentFetchedNewsPage = -1
    private var currentFetchedVideoPage = 0
    
    private (set) var hasFetchedNews = false
    private (set) var hasFetchedVideo = false
    
    private (set) var newsModels = [MKNewsTableViewCellViewModel]()
    private (set) var videoModels = [MKNewsTableViewCellViewModel]()
    
    func fetchNews() {
        let url = getNewsURL(atPage: currentFetchedNewsPage + 1)
        self.fetchingTask?.cancel()
        self.fetchingTask = MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseNewsHTML(html)
            let nextPageURL = self.getNewsURL(atPage: self.currentFetchedNewsPage + 2)
            MKAPIClinet.fetchHTMLFrom(url: nextPageURL, success: { [unowned self] (html) in
                self.parseNewsHTML(html)
                self.currentFetchedNewsPage = self.currentFetchedNewsPage + 2
                self.hasFetchedNews = true
                self.delegate?.viewModel(self, didChangeLoadingStatus: .complete)
                }, failure: { (error) in
                    if error != .cancelled {
                        self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
                    }
            })
        }) { (error) in
            if error != .cancelled {
                self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
            }
        }
    }
    
    func fetchVideo() {
        let url = getVideoURL(atPage: currentFetchedVideoPage + 1)
        self.fetchingTask?.cancel()
        self.fetchingTask = MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseVideoHTML(html)
            self.currentFetchedVideoPage = self.currentFetchedVideoPage + 1
            self.hasFetchedVideo = true
            self.delegate?.viewModel(self, didChangeLoadingStatus: .complete)
        }) { (error) in
            if error != .cancelled {
                self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
            }
        }
    }
}

private extension MKNewsViewModel {
    func parseNewsHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        let headElement = doc.at_xpath("/html/body/div[4]/div/div/div[2]")
        let image = headElement?.at_css("a img")?["src"] ?? ""
        let newsHead = headElement?.at_css(".news_head")
        let title = newsHead?.at_css("div a")?.text
        let date = newsHead?.at_css(".news_head_date")?.text
        
        newsModels.append(MKNewsTableViewCellViewModel(image: image, title: title, date: date, link: getNewsLink(image: image)))
        
        parseNewsRow(doc: doc)
    }
    
    func parseNewsRow(doc: HTMLDocument) {
        let rows = doc.css(".news_row")
        for r in rows {
            guard let dateE = r.at_css(".news_row_date"), let dayE = r.at_css(".day") else {
                continue
            }
            dateE.removeChild(dayE)
            let date = dateE.text?.filter { !"\r\n\t".contains($0) }
            let image = r.at_css("div img")?["src"] ?? ""
            let title = r.at_css(".news_row_title")?.text
            
            newsModels.append(MKNewsTableViewCellViewModel(image: image, title: title, date: date, link: getNewsLink(image: image)))
        }
    }
    
    func getNewsLink(image: String) -> String {
        let id = image.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
        return "http://www.cpbl.com.tw/news/view/" + id
    }
    
    func parseVideoHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        let ul = doc.at_xpath("/html/body/div[2]/div/ul")
        guard let lis = ul?.css("li") else {
            return
        }
        for li in lis {
            let title = li.at_css(".pv-title")?.text
            let date = li.at_css(".date")?.text
            let image = "http:" + (li.at_css("img")?["src"] ?? "")
            let path = li.at_css("div")?["onclick"] ?? ""
            videoModels.append(MKNewsTableViewCellViewModel(image: image, title: title, date: date, link: getVideoLink(path: path)))
        }
    }
    
    func getNewsURL(atPage page: Int) -> String {
        if page == 0 {
            return "http://www.cpbl.com.tw/news/lists.html"
        }
        var components = URLComponents(string: "http://www.cpbl.com.tw/news/lists/news_lits.html")
        components?.queryItems = [
            URLQueryItem(name: "per_page", value: "\(page)")
        ]
        return components?.url?.absoluteString ?? ""
    }
    
    func getVideoURL(atPage page: Int) -> String {
        let base = "https://www.cpbltv.com/highlight.php"
        if page == 1 {
            return base
        }
        var components = URLComponents(string: base)
        components?.queryItems = [
            URLQueryItem(name: "offset", value: "\(page)")
        ]
        return components?.url?.absoluteString ?? ""
    }
    
    func getVideoLink(path: String) -> String {
        let id = path.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
        return "https://www.cpbltv.com/vod.php?vod_id=" + id
    }
}
