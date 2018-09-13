//
//  MKProtocol.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/9/9.
//  Copyright © 2018年 Mission. All rights reserved.
//

import Foundation
import UIKit

protocol MKTableViewCellViewModelProtocol {
}

protocol MKTableViewCellProtocol {
    func applyCellViewModel(_ model: MKTableViewCellViewModelProtocol?)
}
