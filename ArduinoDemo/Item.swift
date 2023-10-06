//
//  Item.swift
//  ArduinoDemo
//
//  Created by Leo Ho on 2023/10/7.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
