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
    func viewModel(_ viewModel: MKStatisticViewModel, didChangeLoadingStatus status: MKViewMode)
}

typealias StatisticTuple = (item: String, name: String, team: String, value: String)

class MKStatisticViewModel {
    weak var delegate: MKStatisticViewModelDelegate?
    
    let hits: [MKStatisticType] = [.avg, .hit, .hr, .rbi, .sb, .tb]
    let pitchs: [MKStatisticType] = [.era, .win, .sv, .so, .whip, .hld]
    
    private (set) var hitTuples = [StatisticTuple]()
    private (set) var pitchTuples = [StatisticTuple]()
    
    func fetchStatistic() {
        let url = "http://www.cpbl.com.tw/stats/toplist.html"
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseStatisticHTML(html)
            self.delegate?.viewModel(self, didChangeLoadingStatus: .complete)
        }) { (error) in
            self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
        }
    }
}

private extension MKStatisticViewModel {
    func parseStatisticHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        for hit in hits {
            let tuple = parseEveryHTML(doc, withIndex: hit.rawValue, item: hit.abbreviation())
            hitTuples.append(tuple)
        }
        
        for pitch in pitchs {
            let tuple = parseEveryHTML(doc, withIndex: pitch.rawValue, item: pitch.abbreviation())
            pitchTuples.append(tuple)
        }
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
