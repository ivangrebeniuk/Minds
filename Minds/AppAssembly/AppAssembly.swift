//
//  AppAssembly.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation

final class AppAssembly {
    
    var mindsListCoordinator: MindListCoordinator {
        MindListCoordinator(
            mindsListAssembly: mindsListAssembly,
            mindDetailsCoordinator: mindDetailsCoordinator
        )
    }
    
    private var mindDetailsCoordinator: MindDetailsCoordinator {
        MindDetailsCoordinator(mindDetailsAssembly: mindDetailsAssembly)
    }
    
    private var mindsListAssembly: MindsListAssembly {
        MindsListAssembly()
    }
    
    private var mindDetailsAssembly: MindDetailsAssembly {
        MindDetailsAssembly()
    }
}
