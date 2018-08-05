//
//  MKTodayViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/8/4.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Kanna

enum MKViewMode: Int {
    case loading = 0, complete, error
}

protocol MKTodayViewModelDelegate: class {
    func viewModel(_ viewModel: MKTodayViewModel, didChangeViewMode: MKViewMode)
}

struct MKCompetitionModel {
    let awayTeam: CPBLTeam
    let homeTeam: CPBLTeam
    private(set) var awayScore = "--"
    private(set) var homeScore = "--"
    let location: String
    let startTime: String?
    let note: String?
}

class MKTodayViewModel {
    
    private (set) var competitions = [MKCompetitionModel]()
    
    private (set) var viewMode: MKViewMode = .loading {
        didSet {
            delegate?.viewModel(self, didChangeViewMode: viewMode)
        }
    }
    
    weak var delegate: MKTodayViewModelDelegate?
    
    func fetchTodayGame() {
        let url = "http://www.cpbl.com.tw/schedule/index/2018-08-04.html"
        
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseHTML(html)
            self.viewMode = .complete
        }) { (error) in
            self.viewMode = .error
        }
    }
}

private extension MKTodayViewModel {
    func parseHTML(_ html: String) {
        if let doc = try? HTML(html: html, encoding: .utf8) {
            if let date = doc.xpath("/html/body/div[4]/div/div/table/tr[3]/td[6]").first {
                let games = date.css("div")
                
                for g in games {
                    let competitionElement = g.at_css("table")
                    let numberElement = competitionElement?.nextSibling
                    let scoreElement = numberElement?.nextSibling
                    
                    guard let competiton = parseGameCompetition(competitionElement), let score = parseGameScore(scoreElement) else {
                        continue
                    }
                    parseGameNumber(numberElement)
                    
                    let model = MKCompetitionModel(awayTeam: competiton.awayTeam, homeTeam: competiton.homeTeam, awayScore: score.awayScore, homeScore: score.homeScore, location: competiton.location, startTime: "17:05", note: nil)
                    
                    competitions.append(model)
                }
            }
        }
    }
    
    func parseGameCompetition(_ element: XMLElement?) -> (awayTeam: CPBLTeam, homeTeam: CPBLTeam, location: String)? {
        guard let awayElement = element?.at_css("td"), let awayTeamImage = awayElement.at_css("img")?["src"] else {
            return nil
        }
        
        guard let locationElement = awayElement.nextSibling, let location = locationElement.text else {
            return nil
        }
        
        guard let homeElement = locationElement.nextSibling, let homeTeamImage = homeElement.at_css("img")?["src"] else {
            return nil
        }
        let awayTeam = CPBLTeam(html: awayTeamImage)
        let homeTeam = CPBLTeam(html: homeTeamImage)
//        print("\(awayTeam.rawValue), \(location), \(homeTeam.rawValue)")
        return (awayTeam, homeTeam, location)
    }
    
    func parseGameNumber(_ element: XMLElement?) {
        guard let number = element?.at_css("tr th")?.nextSibling?.text else {
            return
        }
        print(number)
    }
    
    func parseGameScore(_ element: XMLElement?) -> (awayScore: String, homeScore: String)? {
        guard let awayScoreElement = element?.at_css("td"), let awayScore = awayScoreElement.at_css("span")?.text else {
            return nil
        }
        
        guard let homeScoreElement = awayScoreElement.nextSibling?.nextSibling, let homeScore = homeScoreElement.at_css("span")?.text else {
            return nil
        }
//        print("\(awayScore), \(homeScore)")
        return (awayScore, homeScore)
    }
}
