//
//  AppDelegate.swift
//  Minds
//
//  Created by Иван Гребенюк on 23.09.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private let appAssembly = AppAssembly()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        appCoordinator = AppCoordinator(
            appAssembly: appAssembly,
            window: window
        )
        
        appCoordinator?.start()
        
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

