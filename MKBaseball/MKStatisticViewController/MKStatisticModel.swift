//
//  MKStatisticModel.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/6.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation

enum MKStatisticType: Int {
    case avg = 1, hit, hr, era, win, sv, rbi, sb, so, whip, tb, hld
    
    func abbreviation() -> String {
        switch self {
        case .hit:
            return "H"
        default:
            return "\(self)".uppercased()
        }
    }
    
    func uppercased() -> String {
        return "\(self)".uppercased()
    }
    
    func category() -> String {
        switch self {
        case .avg, .hit, .hr, .rbi, .sb, .tb:
            return "pbat"
        default:
            return "ppit"
        }
    }
    
    func localizedDescription() -> String {
        switch self {
        case .avg:
            return "打擊率"
        case .hit:
            return "安打數"
        case .rbi:
            return "打點"
        case .hr:
            return "全壘打"
        case .tb:
            return "壘打數"
        case .sb:
            return "盜壘成功"
            
        case .era:
            return "防禦率"
        case .win:
            return "勝投"
        case .hld:
            return "中繼點"
        case .whip:
            return "每局被上壘率"
        case .sv:
            return "救援點"
        case .so:
            return "三振數"
        }
    }
    
    func tdIndex() -> Int {
        switch self {
        case .avg:
            return 18
        case .hit:
            return 8
        case .rbi:
            return 6
        case .hr:
            return 12
        case .tb:
            return 13
        case .sb:
            return 15
            
        case .era:
            return 16
        case .win:
            return 9
        case .hld:
            return 13
        case .whip:
            return 15
        case .sv:
            return 11
        case .so:
            return 24
        }
    }
}
