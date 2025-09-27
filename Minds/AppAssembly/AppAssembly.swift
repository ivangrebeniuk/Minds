//
//  AppAssembly.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation

final class AppAssembly {
    
    var mindsListCoordinator: MindListCoordinator {
        MindListCoordinator(mindsListAssembly: mindsListAssembly)
    }
    
    private var mindsListAssembly: MindsListAssembly {
        MindsListAssembly()
    }
}
