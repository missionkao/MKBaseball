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
    let awayScore: String?
    let homeScore: String?
    let location: String
    let number: String
    let currentState: String?
    let note: String?
}

struct MKPlayerChangeModel {
    let player: String
    let team: CPBLTeam
    let date: String
    let reason: String
}

fileprivate typealias MKTodayViewModelTodayGame = MKTodayViewModel
fileprivate typealias MKTodayViewModelPlayerChange = MKTodayViewModel

class MKTodayViewModel {
    
    private (set) var competitions = [MKCompetitionModel]()
    private (set) var changes = [MKPlayerChangeModel]()
    
    private (set) var viewMode: MKViewMode = .loading {
        didSet {
            delegate?.viewModel(self, didChangeViewMode: viewMode)
        }
    }
    
    weak var delegate: MKTodayViewModelDelegate?
    
    func fetchTodayGame() {
        let url = "http://www.cpbl.com.tw/schedule/index/2018-08-04.html"
        
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseTodayGameHTML(html)
            self.viewMode = .complete
        }) { (error) in
            self.viewMode = .error
        }
    }
    
    func fetchPlayerChange() {
        let url = "http://www.cpbl.com.tw/players/change.html"
        
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parsePlayerChangeHTML(html)
            self.viewMode = .complete
        }) { (error) in
            self.viewMode = .error
        }
    }
}

private extension MKTodayViewModelTodayGame {
    func parseTodayGameHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        let rowColumn = todayGameRowAndColumn()
        
        let games = doc.xpath("/html/body/div[4]/div/div/table/tr[\(rowColumn.row)]/td[\(rowColumn.column)]/div")
        
        competitions = [MKCompetitionModel]()
            
        for g in games {
            let competitionElement = g.at_css("table")
            let numberElement = competitionElement?.nextSibling
            let scoreElement = numberElement?.nextSibling
            
            guard let competiton = parseGameCompetition(competitionElement), let score = parseGameScore(scoreElement), let number = parseGameNumber(numberElement) else {
                continue
            }
            
            var currentState = score.currentInning
            if currentState == nil {
                currentState = parseGameInfo(scoreElement?.nextSibling)
            }
            
            guard let current = currentState else {
                continue
            }
            
            let model = MKCompetitionModel(awayTeam: competiton.awayTeam, homeTeam: competiton.homeTeam, awayScore: score.awayScore, homeScore: score.homeScore, location: competiton.location, number: number, currentState: current, note: nil)
            
            competitions.append(model)
        }
    }
    
    // WIP: should be tested
    func todayGameRowAndColumn() -> (row: Int, column: Int) {
        let date = Date()
        let calendar = Calendar.current
        
        let weekMonth = calendar.component(.weekOfMonth, from: date)
        let weekday = calendar.component(.weekday, from: date)
        
        let column = (weekday == 1) ? 7 : weekday - 1
        let row = (weekday == 1) ? weekMonth - 1 : weekMonth
        
        return (2 * row + 1, column)
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
        
        return (awayTeam, homeTeam, location)
    }
    
    func parseGameNumber(_ element: XMLElement?) -> String? {
        guard let number = element?.at_css("tr th")?.nextSibling?.text else {
            return nil
        }
        return number
    }
    
    func parseGameScore(_ element: XMLElement?) -> (awayScore: String?, currentInning: String?, homeScore: String?)? {
        let awayScoreElement = element?.at_css("td")
        
        let awayScore = awayScoreElement?.at_css("span")?.text
        
        var currentInning: String?
        if let currentInningElement = awayScoreElement?.nextSibling {
            currentInning = currentInningElement.at_css("a")?.text
            if currentInning == "" {
                currentInning = "Final"
            }
        }
        
        let homeScore = awayScoreElement?.nextSibling?.nextSibling?.at_css("span")?.text
        
        return (awayScore, currentInning, homeScore)
    }
    
    func parseGameInfo(_ element: XMLElement?) -> String? {
        return element?.at_css("tr td")?.nextSibling?.text
    }
}

private extension MKTodayViewModelPlayerChange {
    func parsePlayerChangeHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        changes = [MKPlayerChangeModel]()
        
        let players = doc.css("#player_tr").reversed()
        
        for p in players {
            let teamElement = p.at_css("td")
            let playerElement = teamElement?.nextSibling
            let dateElement = playerElement?.nextSibling
            let reasonElement = dateElement?.nextSibling
            
            guard let team = teamElement?.text, let player = playerElement?.at_css("a")?.text , let dateString = dateElement?.text, let reason = reasonElement?.text else {
                continue
            }
            
            guard let date = Date(dateString: dateString) else {
                continue
            }
            
            if isDateInThereDays(date) == false {
                break
            }
            
            // changes 中順序為由 新 -> 舊
            changes.append(MKPlayerChangeModel(player: player, team: CPBLTeam(name: team), date: date.dateString(), reason: reason))
        }
    }
    
    func isDateInThereDays(_ date: Date) -> Bool {
        let todayStartDate = Calendar.current.startOfDay(for: Date())
        let threeDaysAgo = todayStartDate.timeIntervalSince1970 - (86400 * 3)
        
        return date.timeIntervalSince1970 > threeDaysAgo
    }
}

private extension Date {
    init?(dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        self = date
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
}
