//
//  Date+Extension.swift
//  Home Report
//
//  Created by Vuk Knezevic on 3/28/19.
//  Copyright © 2019 devhubs. All rights reserved.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
}
