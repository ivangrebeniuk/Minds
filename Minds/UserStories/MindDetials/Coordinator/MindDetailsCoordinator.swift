//
//  MindDetailsCoordinator.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation
import UIKit

final class MindDetailsCoordinator {
    
    private let mindDetailsAssembly: MindDetailsAssembly
    private weak var transitionHandler: UINavigationController?
    
    init(mindDetailsAssembly: MindDetailsAssembly) {
        self.mindDetailsAssembly = mindDetailsAssembly
    }
    
    func start(
        from transitionHandler: UINavigationController?,
        mindId: UUID?
    ) {
        self.transitionHandler = transitionHandler
        let viewController = mindDetailsAssembly.assemble(with: mindId)
        
        transitionHandler?.pushViewController(viewController, animated: true)
    }
}
