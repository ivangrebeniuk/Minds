//
//  MindsListAssembly.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation
import UIKit

final class MindsListAssembly {
    
    init() {}
    
    func assemble(output: IMindsListOutput) -> Module<IMindsListModuleInput> {
        let viewModelFactory = MindsListViewModelFactory()
        let presenter = MindsListPresenter(
            viewModelFactory: viewModelFactory,
            output: output
        )
        let viewController = MindsListViewController(presenter: presenter)
        presenter.view = viewController
        
        return Module(viewController: viewController, moduleInput: presenter)
    }
}
