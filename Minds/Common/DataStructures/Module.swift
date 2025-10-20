//
//  Module.swift
//  Minds
//
//  Created by Иван Гребенюк on 20.10.2025.
//

import UIKit

final class Module<T> {
    
    let viewController: UIViewController
    
    let moduleInput: T
    
    init(viewController: UIViewController, moduleInput: T) {
        self.viewController = viewController
        self.moduleInput = moduleInput
    }
}
