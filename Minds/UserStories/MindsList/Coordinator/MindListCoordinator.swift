//
//  MindListCoordinator.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation
import UIKit

final class MindListCoordinator {
    
    private let mindsListAssembly: MindsListAssembly
    private let mindDetailsCoordinator: MindDetailsCoordinator
    private var navigationController: UINavigationController?
    
    init(
        mindsListAssembly: MindsListAssembly,
        mindDetailsCoordinator: MindDetailsCoordinator,
        navigationController: UINavigationController? = nil
    ) {
        self.mindsListAssembly = mindsListAssembly
        self.mindDetailsCoordinator = mindDetailsCoordinator
        self.navigationController = navigationController
    }
    
    func start(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        let mindListModule = mindsListAssembly.assemble(output: self)
        
        navigationController.pushViewController(mindListModule, animated: true)
    }
}

extension MindListCoordinator: IMindsListOutput {
    
    func didSelectMind(with id: UUID?) {
        mindDetailsCoordinator.start(from: navigationController, mindId: id)
    }
}
