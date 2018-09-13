//
//  MKStatisticPopupViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/6.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation
import Kanna

protocol MKStatisticPopupViewModelDelegate: class {
    func viewModel(_ viewModel: MKStatisticPopupViewModel, didChangeLoadingStatus status: MKViewMode)
}

typealias StatisticRankTuple = (rank: String, name: String, team: String, value: String)

class MKStatisticPopupViewModel {
    weak var delegate: MKStatisticPopupViewModelDelegate?
    
    private (set) var statisticTuples = [StatisticRankTuple]()
    
    private let year: String
    let type: MKStatisticType
    
    init(type: MKStatisticType) {
        self.year = "\(Calendar.current.component(.year, from: Date()))"
        self.type = type
    }
    
    func fetchStatistic() {
        var components = URLComponents(string: "http://www.cpbl.com.tw/stats/all.html")
        components?.queryItems = [
            URLQueryItem(name: "game_type", value: "01"),
            URLQueryItem(name: "year", value: year),
            URLQueryItem(name: "stat", value: type.category()),
            URLQueryItem(name: "sort", value: type.uppercased()),
            URLQueryItem(name: "order", value: "desc")
        ]
        let url = components?.url?.absoluteString ?? ""
        
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseStatisticTable(html)
            self.delegate?.viewModel(self, didChangeLoadingStatus: .complete)
        }) { (error) in
            self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
        }
    }
}

private extension MKStatisticPopupViewModel {
    func parseStatisticTable(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        let table = doc.at_xpath("/html/body/div[4]/div/div/div[4]/table")
        
        guard let trs = table?.css("tr") else {
            return
        }
        
        for (index, element) in trs.enumerated() {
            if index == 0 {
                continue
            }
            parseTrElement(element, atTdIndex: self.type.tdIndex())
        }
    }
    
    func parseTrElement(_ element: XMLElement, atTdIndex index: Int) {
        let rankE = element.at_xpath("td[1]")
        let rank = rankE?.text ?? ""
        
        let teamAndName = rankE?.nextSibling
        let teamImage = teamAndName?.at_css("img")?["src"] ?? ""
        let team = CPBLTeam(html: teamImage)
        
        let name = teamAndName?.at_css("a")?.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        let value = element.at_xpath("td[\(index)]")?.text ?? ""
        
        self.statisticTuples.append((rank, name, team.rawValue, value))
    }
}
