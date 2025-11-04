//
//  MindListCoordinator.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation
import UIKit

protocol IMindsListModuleInput: AnyObject {
    
    func didSaveMind()
}

final class MindListCoordinator {
    
    private let mindsListAssembly: MindsListAssembly
    private let mindDetailsCoordinator: MindDetailsCoordinator
    private var navigationController: UINavigationController?
    private weak var mindsListModuleInput: IMindsListModuleInput?
    
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
        self.mindsListModuleInput = mindListModule.moduleInput
        navigationController.pushViewController(mindListModule.viewController, animated: true)
    }
}

// MARK: - IMindsListOutput

extension MindListCoordinator: IMindsListOutput {
    
    func didSelectMind(with id: UUID?) {
        mindDetailsCoordinator.start(
            from: navigationController,
            mindId: id,
            moduleOutput: self
        )
    }
}

// MARK: - IMindDetailsModuleOutput

extension MindListCoordinator: IMindDetailsModuleOutput {
    
    func didSaveMind() {
        mindsListModuleInput?.didSaveMind()
    }
}
