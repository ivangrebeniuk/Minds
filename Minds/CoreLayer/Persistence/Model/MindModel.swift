//
//  NoteModel.swift
//  Minds
//
//  Created by Иван Гребенюк on 27.09.2025.
//

import Foundation

struct MindModel: Identifiable, Codable {
    let id: UUID
    var text: String
    var time: Date
}
