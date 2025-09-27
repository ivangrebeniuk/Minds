//
//  ConfigurableView.swift
//  Minds
//
//  Created by Иван Гребенюк on 27.09.2025.
//

import UIKit

protocol ConfigurableView {
    
    associatedtype ConfigurableModel
    
    func configure(with model: ConfigurableModel)
}
