//
//  MKConstant.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/26.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation

let TEAM_NAME_LION = "統一7-ELEVEn"
let TEAM_NAME_ELEPHANT = "中信兄弟"
let TEAM_NAME_GUARDIANS = "富邦悍將"
let TEAM_NAME_MONKEY = "Lamigo"

enum CPBLTeam: String {
    case lion = "統一7-ELEVEn"
    case elephant = "中信兄弟"
    case guardians = "富邦悍將"
    case monkey = "Lamigo"
    
    func logoImageName() -> String {
        switch self {
        case .lion: return "Score_L_logo"
        case .elephant: return "Score_B_logo"
        case .guardians: return "Score_G_logo"
        case .monkey: return "Score_ M_logo"
        }
    }
}
