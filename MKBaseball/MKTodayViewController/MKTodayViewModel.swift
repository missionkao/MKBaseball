//
//  MKTodayViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/8/4.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Kanna

protocol MKTodayViewModelDelegate: class {
    func viewModel(_ viewModel: MKTodayViewModel, didChangeLoadingStatus status: MKViewMode)
}

fileprivate typealias MKTodayViewModelTodayGame = MKTodayViewModel
fileprivate typealias MKTodayViewModelPlayerChange = MKTodayViewModel

class MKTodayViewModel {
    
    private (set) var competitions = [MKCompetitionModel]()
    private (set) var changes = [MKPlayerChangeModel]()
    private var fetchingTask: URLSessionDataTask?
    weak var delegate: MKTodayViewModelDelegate?
    
    func fetchTodayGame() {
        let url = "http://www.cpbl.com.tw/schedule/index.html"
        self.fetchingTask?.cancel()
        self.fetchingTask = MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parseTodayGameHTML(html)
            self.fetchPlayerChange(success: {
                self.delegate?.viewModel(self, didChangeLoadingStatus: .complete)
            }, failure: { (error) in
                self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
            })
        }) { (error) in
            print("fetchTodayGame Error!!!!!!!!!")
            self.delegate?.viewModel(self, didChangeLoadingStatus: .error)
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
        
        competitions = MKGameParserHelper.parseGamesToCompetitionModels(games: games)
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
}

private extension MKTodayViewModelPlayerChange {
    func fetchPlayerChange(success: @escaping () -> Void, failure: @escaping (Error?) -> Void) {
        let url = "http://www.cpbl.com.tw/players/change.html"
        
        MKAPIClinet.fetchHTMLFrom(url: url, success: { [unowned self] (html) in
            self.parsePlayerChangeHTML(html)
            success()
        }) { (error) in
            print("fetchPlayerChange Error!!!!!!!!!")
            failure(error)
        }
    }
    
    func parsePlayerChangeHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        changes = [MKPlayerChangeModel]()
        
        //FIX: 如果是月初, 就擷取不到上個月底的球員異動
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
            
            if isDateInThreeDays(date) == false {
                break
            }
            
            // changes 中順序為由 新 -> 舊
            changes.append(MKPlayerChangeModel(player: player, team: CPBLTeam(name: team), date: date.dateString(), reason: reason))
        }
    }
    
    func isDateInThreeDays(_ date: Date) -> Bool {
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
