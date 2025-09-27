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
    
    func assemble() -> UIViewController {
        let viewModelFactory = MindsListViewModelFactory()
        let presenter = MindsListPresenter(viewModelFactory: viewModelFactory)
        let viewController = MindsListViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
