//
//  MKRankingViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/8/7.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation
import Kanna

enum MKSeasonMode: Int {
    case top = 0, bottom, whole
    
    func rankURL() -> String {
        switch self {
        case .top:
            return "http://www.cpbl.com.tw/standing/season/?&season=1"
        case .bottom:
            return "http://www.cpbl.com.tw/standing/season/?&season=2"
        case .whole:
            return "http://www.cpbl.com.tw/standing/season/?&season=0"
        }
    }
}

struct MKTeamRankingModel {
    let number: String
    let team: CPBLTeam
    let total: String
    let winLose: String
    let winRate: String
    let winDiff: String
}

struct MKTeamBetweenModel {
    let team: CPBLTeam
    let first: String
    let second: String
    let third: String
    let fourth: String
}

struct MKTeamGradeModel {
    let team: CPBLTeam
    let goal: String
    let lose: String
    let hr: String
    let hitRate: String
    let era: String
}

protocol MKRankingViewModelDelegate: class {
    func viewModel(_ viewModel: MKRankingViewModel, didChangeLoadingStatus status: MKViewMode)
}

class MKRankingViewModel {
    private (set) var teamRanks = [MKTeamRankingModel]()
    private (set) var teamBetweens = [MKTeamBetweenModel]()
    private (set) var teamGrades = [MKTeamGradeModel]()
    
    let defaultSelectedSegmentIndex: Int = {
        let month = Calendar.current.component(.month, from: Date())
        return (month < 7) ? 0 : 1
    }()
    
    weak var delegate: MKRankingViewModelDelegate?
    
    func fetchRanking(seasonMode: MKSeasonMode? = nil) {
        let url: String!
        if let mode = seasonMode {
            url = mode.rankURL()
        } else {
            url = "http://www.cpbl.com.tw/standing/season"
        }
        
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseRankingHTML(html)
            self.parseTeamGradeHTML(html)
            self.delegate?.viewModel(self, didChangeLoadingStatus: .complete)
        }) { (error) in
            self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
        }
    }
}

private extension MKRankingViewModel {
    func parseRankingHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        let rankTable = doc.at_xpath("/html/body/div[4]/div/div/div[4]/table[1]")
        guard let ranks = rankTable?.css("tr") else {
            return
        }
        
        teamRanks = [MKTeamRankingModel]()
        teamBetweens = [MKTeamBetweenModel]()
        
        for (index, element) in ranks.enumerated() {
            if index == 0 {
                continue
            }
            guard let info = parseTeamRankInfo(element) else {
                continue
            }
            teamRanks.append(info.rankModel)
            teamBetweens.append(info.betweenModel)
        }
    }
    
    func parseTeamRankInfo(_ element: XMLElement?) -> (rankModel: MKTeamRankingModel, betweenModel: MKTeamBetweenModel)? {
        let rankE = element?.at_css("td")
        let teamE = rankE?.nextSibling
        let totalE = teamE?.nextSibling
        let winLoseE = totalE?.nextSibling
        let winRateE = winLoseE?.nextSibling
        let winDiffE = winRateE?.nextSibling
        
        guard let rank = rankE?.text, let team = teamE?.text, let total = totalE?.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(), let winLose = winLoseE?.text, let winRate = winRateE?.text, let winDiff = winDiffE?.text else {
            return nil
        }
        
        let rankModel = MKTeamRankingModel(number: rank, team: CPBLTeam(name: team), total: total, winLose: winLose, winRate: winRate, winDiff: winDiff)
        let betweenModel = parseTeamBetweenElement(winDiffE, team: CPBLTeam(name: team))
        
        return (rankModel, betweenModel)
    }
    
    func parseTeamBetweenElement(_ element: XMLElement?, team: CPBLTeam) -> MKTeamBetweenModel {
        let firstE = element?.nextSibling?.nextSibling
        let secondE = firstE?.nextSibling
        let thirdE = secondE?.nextSibling
        let fourthE = thirdE?.nextSibling
        return MKTeamBetweenModel(team: team, first: firstE?.text ?? "", second: secondE?.text ?? "", third: thirdE?.text ?? "", fourth: fourthE?.text ?? "")
    }
    
    func parseTeamGradeHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        guard let pitchTuples = parsePitchTable(doc), let hitTuples = parseHitTable(doc) else {
            return
        }
        
        if pitchTuples.count != hitTuples.count {
            return
        }
        
        teamGrades = [MKTeamGradeModel]()
        
        for (index, pitchTuple) in pitchTuples.enumerated() {
            let team = pitchTuple.team
            let lose = pitchTuple.lose
            let era = pitchTuple.era
            
            let hitTuple = hitTuples[index]
            let goal = hitTuple.goal
            let hr = hitTuple.hr
            let hitRate = hitTuple.hitRate
            
            let model = MKTeamGradeModel(team: CPBLTeam(name: team), goal: goal, lose: lose, hr: hr, hitRate: hitRate, era: era)
            teamGrades.append(model)
        }
    }
    
    func parsePitchTable(_ html: HTMLDocument) -> [(team: String, lose: String, era: String)]? {
        let pitchTable = html.at_xpath("/html/body/div[4]/div/div/div[4]/table[2]")
        
        guard let pitchs = pitchTable?.css("tr") else {
            return nil
        }
        
        var pitchTuples = [(team: String, lose: String, era: String)]()
        
        for (index, element) in pitchs.enumerated() {
            if index == 0 {
                continue
            }
            let tds = element.css("td")
            let teamE = tds.first
            let reversedTds = tds.reversed()
            let eraE = reversedTds.first
            let loseE = reversedTds[3]
            
            guard let team = teamE?.text, let lose = loseE.text, let era = eraE?.text else {
                continue
            }
            
            pitchTuples.append((team, lose, era))
        }
        
        return pitchTuples
    }
    
    func parseHitTable(_ html: HTMLDocument) -> [(team: String, goal: String, hr: String, hitRate: String)]? {
        let hitTable = html.at_xpath("/html/body/div[4]/div/div/div[4]/table[3]")
        
        guard let hits = hitTable?.css("tr") else {
            return nil
        }
        
        var hitTuples = [(team: String, goal: String, hr: String, hitRate: String)]()
        
        for (index, element) in hits.enumerated() {
            if index == 0 {
                continue
            }
            let tds = element.css("td")
            let teamE = tds.first
            let goalE = tds[3]
            let hrE = tds[6]
            let hitRateE = tds[tds.count - 1]
            
            guard let team = teamE?.text, let goal = goalE.text, let hr = hrE.text, let hitRate = hitRateE.text else {
                continue
            }
            
            hitTuples.append((team, goal, hr, hitRate))
        }
        
        return hitTuples
    }
}
