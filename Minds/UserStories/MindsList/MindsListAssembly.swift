//
//  MindsListAssembly.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation
import UIKit

final class MindsListAssembly {
    
    private let mindService: MindServiceProtocol
    
    init(mindService: MindServiceProtocol) {
        self.mindService = mindService
    }
    
    @MainActor
    func assemble(output: IMindsListOutput) -> Module<IMindsListModuleInput> {
        let viewModelFactory = MindsListViewModelFactory()
        let presenter = MindsListPresenter(
            viewModelFactory: viewModelFactory,
            mindService: mindService,
            output: output
        )
        let viewController = MindsListViewController(presenter: presenter)
        presenter.view = viewController
        
        if let mindService = mindService as? MindService {
            mindService.delegate = presenter
        }
        
        return Module(viewController: viewController, moduleInput: presenter)
    }
}
