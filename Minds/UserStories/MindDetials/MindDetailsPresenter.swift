//
//  MindDetailsPresenter.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation

protocol IMindDetailsView: AnyObject {
    
    func updateUI()
}

protocol IMindDetailsPresenter {
    
    func viewDidLoad()
    
    func didTapBackButton()
    
    func didTapSaveButton()
}

final class MindDetailsPresenter {
    
    weak var view: IMindDetailsView?
    private let mindId: UUID?
    private let viewModelFactory: IMindDetailsViewModelFactory
    
    // MARK: - Init
    
    init(
        mindId: UUID?,
        viewModelFactory: IMindDetailsViewModelFactory
    ) {
        self.mindId = mindId
        self.viewModelFactory = viewModelFactory
    }
}

extension MindDetailsPresenter: IMindDetailsPresenter {
    
    func viewDidLoad() {
        print("view did load")
    }
        
    func didTapBackButton() {}
    

    func didTapSaveButton() {}
}

        
