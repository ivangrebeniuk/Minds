//
//  MindsListPresenter.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation

protocol IMindsListPresenter: AnyObject {
    
    func viewDidLoad()
}

final class MindsListPresenter {
    
    weak var view: IMindsListView?
    private let viewModelFactory: IMindsListViewModelFactory
    
    // MARK: - Init
    
    init(viewModelFactory: IMindsListViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
}

// MARK: - IMindsListPresenter

extension MindsListPresenter: IMindsListPresenter {
    
    func viewDidLoad() {}
}
