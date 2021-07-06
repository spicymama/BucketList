//
//  DateFormatter.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/5/21.
//

import Foundation

extension Date {
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
} // End of Extension
