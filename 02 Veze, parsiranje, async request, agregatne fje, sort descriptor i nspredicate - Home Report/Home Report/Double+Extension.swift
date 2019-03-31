//
//  Double+Extension.swift
//  Home Report
//
//  Created by Vuk Knezevic on 3/28/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import Foundation

extension Double {
    var currencyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self))!
    }
}
