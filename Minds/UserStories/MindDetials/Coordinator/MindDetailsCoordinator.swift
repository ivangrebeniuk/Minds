//
//  MindDetailsCoordinator.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation
import UIKit

protocol IMindDetailsModuleOutput: AnyObject {
    
    func didSaveNewMind()
}

final class MindDetailsCoordinator {
    
    private let mindDetailsAssembly: MindDetailsAssembly
    private weak var moduleOutput: IMindDetailsModuleOutput?
    private weak var transitionHandler: UINavigationController?
    
    init(mindDetailsAssembly: MindDetailsAssembly) {
        self.mindDetailsAssembly = mindDetailsAssembly
    }
    
    func start(
        from transitionHandler: UINavigationController?,
        mindId: UUID?,
        moduleOutput: IMindDetailsModuleOutput?
        
    ) {
        self.transitionHandler = transitionHandler
        self.moduleOutput = moduleOutput
        let viewController = mindDetailsAssembly.assemble(
            with: mindId,
            output: self
        )
        
        transitionHandler?.pushViewController(viewController, animated: true)
    }
}

extension MindDetailsCoordinator: IMindDetailsOutput {
    
    func didTapSaveButton() {
        print("Did tap save")
        moduleOutput?.didSaveNewMind()
        transitionHandler?.popViewController(animated: true)
    }
}
