//
//  AppCoordinator.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation
import UIKit

final class AppCoordinator {
    
    private let appAssembly: AppAssembly
    private lazy var mindsListCoordinator = appAssembly.mindsListCoordinator
    private var window: UIWindow
    
    init(appAssembly: AppAssembly, window: UIWindow) {
        self.appAssembly = appAssembly
        self.window = window
    }
    
    @MainActor func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        mindsListCoordinator.start(with: navigationController)
    }
}
