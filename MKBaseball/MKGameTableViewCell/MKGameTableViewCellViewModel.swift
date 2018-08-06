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
    let awayScore: String?
    let homeScore: String?
    let location: String
    let currentState: String?
    let note: String?
    
    init(model: MKCompetitionModel) {
        awayTeam = model.awayTeam
        homeTeam = model.homeTeam
        awayScore = model.awayScore ?? "--"
        homeScore = model.homeScore ?? "--"
        location = model.location
        currentState = model.currentState
        note = model.note
    }
    
    static func parsing(htmlString: String) -> MKGameTableViewCellViewModel {
        let awayTeam: CPBLTeam = .elephant
        let homeTeam: CPBLTeam = .guardians
        let awayScore = "0"
        let homeScore = "1"
        let location = "新莊"
        var currentState: String?
        var note: String?
        
        currentState = "17:05"
        note = nil
        
        let model = MKCompetitionModel(awayTeam: awayTeam, homeTeam: homeTeam, awayScore: awayScore, homeScore: homeScore, location: location, number: "158", currentState: currentState, note: note)
        
        return MKGameTableViewCellViewModel(model: model)
    }
}
