//
//  Item.swift
//  BlogDemos
//
//  Created by Jenya Lebid on 7/28/24.
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
