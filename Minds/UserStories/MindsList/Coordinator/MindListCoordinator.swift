//
//  MindListCoordinator.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation
import UIKit

final class MindListCoordinator {
    
    let mindsListAssembly: MindsListAssembly
    var navigationController: UIViewController?
    
    init(
        mindsListAssembly: MindsListAssembly,
        navigationController: UIViewController? = nil
    ) {
        self.mindsListAssembly = mindsListAssembly
        self.navigationController = navigationController
    }
    
    func start(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        let mindListModule = mindsListAssembly.assemble()
        
        navigationController.pushViewController(mindListModule, animated: true)
    }
}
