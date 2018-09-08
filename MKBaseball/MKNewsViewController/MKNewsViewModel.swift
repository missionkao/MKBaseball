//
//  MKNewsViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/6.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation
import Kanna

protocol MKNewsViewModelDelegate: class {
    func viewModel(_ viewModel: MKNewsViewModel, didChangeViewMode: MKViewMode)
}

class MKNewsViewModel {
    weak var delegate: MKNewsViewModelDelegate?
    
    private var fetchingTask: URLSessionDataTask?
    private (set) var hasfetchedVideo = false
    private (set) var newsModels = [MKNewsTableViewCellViewModel]()
    private (set) var videoModels = [MKNewsTableViewCellViewModel]()
    
    func fetchNews(page: Int = 0) {
        let url = "http://www.cpbl.com.tw/news/lists.html"
        self.fetchingTask?.cancel()
        self.fetchingTask = MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseNewsHTML(html)
            self.delegate?.viewModel(self, didChangeViewMode: .complete)
        }) { (error) in
        }
    }
    
    func fetchVideo(page: Int = 0) {
        let url = "https://www.cpbltv.com/highlight.php"
        self.fetchingTask?.cancel()
        self.fetchingTask = MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseVideoHTML(html)
            self.hasfetchedVideo = true
            self.delegate?.viewModel(self, didChangeViewMode: .complete)
        }) { (error) in
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
        let path = newsHead?.at_css("div a")?["href"] ?? ""
        let date = newsHead?.at_css(".news_head_date")?.text
        
        newsModels.append(MKNewsTableViewCellViewModel(image: image, title: title, date: date, link: getNewsLink(path: path)))
        
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
            let path = r.at_css("div div a")?["href"] ?? ""
            
            newsModels.append(MKNewsTableViewCellViewModel(image: image, title: title, date: date, link: getNewsLink(path: path)))
        }
    }
    
    func getNewsLink(path: String) -> String {
        var uc = URLComponents()
        uc.scheme = "http"
        uc.host = "www.cpbl.com.tw"
        uc.path = "/news/lists"
        
        return uc.url?.absoluteString ?? ""
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
            let link = li.at_css("div")?["onclick"] ?? ""
            videoModels.append(MKNewsTableViewCellViewModel(image: image, title: title, date: date, link: link))
        }
    }
}
