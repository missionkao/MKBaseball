//
//  MKScheduleViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/8/8.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Kanna

protocol MKScheduleViewModelDelegate: class {
    func viewModel(_ viewModel: MKScheduleViewModel, didChangeViewMode: MKViewMode)
}

class MKScheduleViewModel {
    weak var delegate: MKScheduleViewModelDelegate?
    
    var allGames = [(date: String, model: [MKCompetitionModel])]()
    var dateArray = [Int]()
    var currentMonth: Int = 0
    
    private (set) var viewMode: MKViewMode = .loading {
        didSet {
            delegate?.viewModel(self, didChangeViewMode: viewMode)
        }
    }
    
    func fetchSchedule(atYear year: Int, month: Int, forceUpdate: Bool = false) {
        if month == currentMonth && forceUpdate == false {
            return
        }
        currentMonth = month
        viewMode = .loading
        
        var components = URLComponents(string: "http://www.cpbl.com.tw/schedule/index/\(year)-\(month)-01.html")
        components?.queryItems = [
            URLQueryItem(name: "date", value: "\(year)-\(month)-01"),
            URLQueryItem(name: "gameno", value: "01"),
            URLQueryItem(name: "sgameno", value: "01")
        ]
        let scheduleURL = components?.url?.absoluteString ?? ""
        
        MKAPIClinet.fetchHTMLFrom(url: scheduleURL, success: { [unowned self] (html) in
            self.parseScheduleHTML(html)
            self.viewMode = .complete
        }) { (error) in
            self.viewMode = .error
        }
    }
    
    func getNearestDateIndex() -> Int {
        let today = Calendar.current.component(.day, from: Date())
        for (index, value) in dateArray.enumerated() {
            if value >= today {
                return index
            }
        }
        return 0
    }
}

private extension MKScheduleViewModel {
    func parseScheduleHTML(_ html: String) {
        guard let doc = try? HTML(html: html, encoding: .utf8) else {
            return
        }
        
        let scheduleTable = doc.at_xpath("/html/body/div[4]/div/div/table")
        
        guard let weekdaysE = scheduleTable?.at_css("tr") else {
            return
        }
        
        allGames = [(date: String, model: [MKCompetitionModel])]()
        dateArray = [Int]()
        var dateE: XMLElement? = weekdaysE.nextSibling
        
        while dateE != nil {
            guard let gameEs = dateE?.nextSibling else {
                dateE = dateE?.nextSibling?.nextSibling
                continue
            }
            
            parseAWeekOfGames(weekdaysE: weekdaysE, dateEs: dateE!, gameEs: gameEs)
            dateE = dateE?.nextSibling?.nextSibling
        }
    }
    
    //parse 出那週的對戰
    func parseAWeekOfGames(weekdaysE: XMLElement, dateEs: XMLElement, gameEs: XMLElement) {
        var targetGameE = gameEs.at_css("td")
        
        //一週七天, 故理論上只需跑 7 次
        for index in 0...6 {
            if index > 0 {
                targetGameE = targetGameE?.nextSibling
            }
            
            guard let games = targetGameE?.css("div") else {
                continue
            }
            // games: 此日的對戰組合 div
            if games.count == 0 {
                continue
            }
            
            let dateE = dateEs.css("th")[index % 7]
            let weekday = convertIndexToWeekday(index)
            let date = "\(currentMonth)月\(dateE.text ?? "")日 (\(weekday))"
            let gameModels = MKGameParserHelper.parseGamesToCompetitionModels(games: games)
            
            allGames.append((date, gameModels))
            
            if let d = dateE.text, let dateInt = Int(d) {
                dateArray.append(dateInt)
            }
        }
    }
    
    func convertIndexToWeekday(_ index: Int) -> String {
        if index == 0 {
            return "一"
        } else if index == 1 {
            return "二"
        } else if index == 2 {
            return "三"
        } else if index == 3 {
            return "四"
        } else if index == 4 {
            return "五"
        } else if index == 5 {
            return "六"
        }
        
        return "日"
    }
}
