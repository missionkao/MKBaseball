//
//  MKStatisticViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/3.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation
import Kanna

protocol MKStatisticViewModelDelegate: class {
    func viewModel(_ viewModel: MKStatisticViewModel, didChangeViewMode: MKViewMode)
}

typealias StatisticTuple = (item: String, name: String, team: String, value: String)

class MKStatisticViewModel {
    weak var delegate: MKStatisticViewModelDelegate?
    
    private (set) var viewMode: MKViewMode = .loading {
        didSet {
            delegate?.viewModel(self, didChangeViewMode: viewMode)
        }
    }
    
    private var avgTop: StatisticTuple = (item: "AVG", name: "", team: "", value: "")
    private var hitTop: StatisticTuple = (item: "H", name: "", team: "", value: "")
    private var hrTop: StatisticTuple = (item: "HR", name: "", team: "", value: "")
    private var rbiTop: StatisticTuple = (item: "RBI", name: "", team: "", value: "")
    private var tbTop: StatisticTuple = (item: "TB", name: "", team: "", value: "")
    private var sbTop: StatisticTuple = (item: "SB", name: "", team: "", value: "")
    
    private var eraTop: StatisticTuple = (item: "ERA", name: "", team: "", value: "")
    private var winTop: StatisticTuple = (item: "W", name: "", team: "", value: "")
    private var svTop: StatisticTuple = (item: "SV", name: "", team: "", value: "")
    private var soTop: StatisticTuple = (item: "SO", name: "", team: "", value: "")
    private var whipTop: StatisticTuple = (item: "WHIP", name: "", team: "", value: "")
    private var hldTop: StatisticTuple = (item: "HLD", name: "", team: "", value: "")
    
    private (set) var hitTuples = [StatisticTuple]()
    private (set) var defenseTuples = [StatisticTuple]()
    
    func fetchStatistic() {
        let url = "http://www.cpbl.com.tw/stats/toplist.html"
        self.viewMode = .loading
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseStatisticHTML(html)
            self.viewMode = .complete
        }) { (error) in
            self.viewMode = .error
        }
    }
}

private extension MKStatisticViewModel {
    func parseStatisticHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        self.avgTop = parseEveryHTML(doc, withIndex: 1, item: "AVG")
        self.hitTop = parseEveryHTML(doc, withIndex: 2, item: "H")
        self.hrTop = parseEveryHTML(doc, withIndex: 3, item: "HR")
        
        self.eraTop = parseEveryHTML(doc, withIndex: 4, item: "ERA")
        self.winTop = parseEveryHTML(doc, withIndex: 5, item: "W")
        self.svTop = parseEveryHTML(doc, withIndex: 6, item: "SV")
        
        self.rbiTop = parseEveryHTML(doc, withIndex: 7, item: "RBI")
        self.sbTop = parseEveryHTML(doc, withIndex: 8, item: "SB")
        self.soTop = parseEveryHTML(doc, withIndex: 9, item: "SO")
        
        self.whipTop = parseEveryHTML(doc, withIndex: 10, item: "WHIP")
        self.tbTop = parseEveryHTML(doc, withIndex: 11, item: "TB")
        self.hldTop = parseEveryHTML(doc, withIndex: 12, item: "HLD")
        
        self.hitTuples = [self.avgTop, self.hitTop, self.hrTop, self.rbiTop, self.sbTop, self.tbTop]
        self.defenseTuples = [self.eraTop, self.winTop, self.svTop, self.soTop, self.whipTop, self.hldTop]
    }
    
    func parseEveryHTML(_ doc: HTMLDocument, withIndex: Int, item: String) -> StatisticTuple {
        let element = doc.at_xpath("/html/body/div[4]/div/div/div[3]/div[\(withIndex)]/table/tr[2]")
        let teamE = element?.at_css("td")?.nextSibling
        let nameE = teamE?.nextSibling
        let valueE = nameE?.nextSibling
        
        let name = nameE?.at_css("a")?.text ?? ""
        let team = teamE?.at_css("a")?.text ?? ""
        let value = valueE?.text ?? ""
        
        return (item, name, CPBLTeam(name: team).rawValue, value)
    }
}
