//
//  MKGameTableViewCellViewModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/28.
//  Copyright © 2018年 Mission. All rights reserved.
//

struct MKGameTableViewCellViewModel {
    let awayTeam: CPBLTeam
    let homeTeam: CPBLTeam
    private(set) var awayScore = "--"
    private(set) var homeScore = "--"
    let location: String
    let startTime: String?
    let note: String?
    
    static func parsing(htmlString: String) -> MKGameTableViewCellViewModel {
        let awayTeam: CPBLTeam = .elephant
        let homeTeam: CPBLTeam = .guardians
        let awayScore = "0"
        let homeScore = "1"
        let location = "新莊"
        var startTime: String?
        var note: String?
        
        startTime = "17:05"
        note = nil
        
        return MKGameTableViewCellViewModel(awayTeam: awayTeam, homeTeam: homeTeam, awayScore: awayScore, homeScore: homeScore, location: location, startTime: startTime, note: note)
    }
}
