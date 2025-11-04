//
//  Mind.swift
//  Minds
//
//  Created by Иван Гребенюк on 27.09.2025.
//

import Foundation

struct Mind: Identifiable, Codable {
    let id: UUID
    var text: String
    var timestamp: Date
}
