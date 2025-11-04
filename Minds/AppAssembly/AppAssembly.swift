//
//  AppAssembly.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation

final class AppAssembly {
    
    private lazy var coreDataService = CoreDataService()
    
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
        MindsListAssembly(mindService: mindService)
    }
    
    private var mindDetailsAssembly: MindDetailsAssembly {
        MindDetailsAssembly(mindService: mindService)
    }
    
    private lazy var mindService = MindService(coreDataService: coreDataService)
}
