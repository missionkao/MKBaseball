//
//  MKConstant.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/26.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation

let TEAM_NAME_LION = "統一獅"
let TEAM_NAME_ELEPHANT = "中信兄弟"
let TEAM_NAME_GUARDIANS = "富邦悍將"
let TEAM_NAME_MONKEY = "Lamigo猿"

enum CPBLTeam: String {
    case lion = "統一獅"
    case elephant = "中信兄弟"
    case guardians = "富邦悍將"
    case monkey = "Lamigo猿"
    
    init(html: String) {
        if html.contains("B04") {
            self = .guardians
            return
        }
        if html.contains("E02") {
            self = .elephant
            return
        }
        if html.contains("A02") {
            self = .monkey
            return
        }
        self = .lion
    }
    
    init(name: String) {
        if name.contains("富邦") {
            self = .guardians
            return
        }
        if name.contains("Lamigo") {
            self = .monkey
            return
        }
        if name.contains("兄弟") {
            self = .elephant
            return
        }
        self = .lion
    }
    
    func logoImageName() -> String {
        switch self {
        case .lion: return "Score_L_logo"
        case .elephant: return "Score_B_logo"
        case .guardians: return "Score_G_logo"
        case .monkey: return "Score_M_logo"
        }
    }
}
