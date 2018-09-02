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
}
