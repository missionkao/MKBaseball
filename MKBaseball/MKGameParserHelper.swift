//
//  MKGameParserHelper.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/2.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation
import Kanna

class MKGameParserHelper {
    static func parseGamesToCompetitionModels(games: XPathObject) -> [MKCompetitionModel] {
        var competitions = [MKCompetitionModel]()
        
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
        
        return competitions
    }
}

private extension MKGameParserHelper {
    //找出是哪兩隊在打
    static func parseGameCompetition(_ element: XMLElement?) -> (awayTeam: CPBLTeam, homeTeam: CPBLTeam, location: String)? {
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
    
    //找出對戰分數
    static func parseGameScore(_ element: XMLElement?) -> (awayScore: String?, currentInning: String?, homeScore: String?)? {
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
    
    //找出對戰場數
    static func parseGameNumber(_ element: XMLElement?) -> String? {
        //第一個 th 可能為`補賽`, `保留`
        //第三個 th 可能為`雙賽1`, `雙賽2`
        guard let number = element?.at_css("tr th")?.nextSibling?.text else {
            return nil
        }
        return number
    }
    
    static func parseGameInfo(_ element: XMLElement?) -> String? {
        //tr td .next 為比賽時間
        //Fix: 可能只有 tr td span 為延賽資訊
        return element?.at_css("tr td")?.nextSibling?.text
    }
}

