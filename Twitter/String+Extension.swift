//
//  String+Extension.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/29/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import Foundation
import FormatterKit

extension String {
    func getTimeIntervalString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        let interval = date.timeIntervalSinceNow
        let timeIntervalFormatter = TTTTimeIntervalFormatter()
        
        guard let timeIntervalString = timeIntervalFormatter.string(forTimeInterval: interval) else {
            return ""
        }
        return timeIntervalString
    }
}
