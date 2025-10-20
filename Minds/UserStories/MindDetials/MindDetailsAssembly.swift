//
//  MindDetailsAssembly.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation
import UIKit

final class MindDetailsAssembly {
    
    func assemble(with mindId: UUID?, output: IMindDetailsOutput?) -> UIViewController {
        
        let presenter = MindDetailsPresenter(
            mindId: mindId,
            output: output
        )
        
        let viewController = MindDetailsViewController(presenter: presenter)
        
        presenter.view = viewController
        return viewController
    }
}
