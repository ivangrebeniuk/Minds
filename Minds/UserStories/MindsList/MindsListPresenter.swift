//
//  MindsListPresenter.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation

protocol IMindsListOutput: AnyObject {
    
    func didSelectMind(with id: UUID?)
}

protocol IMindsListView: AnyObject {
    
    @MainActor
    func updateTableView(with: [MindCell.Model])
    
    @MainActor
    func insertItem(_ item: MindCell.Model)
    
    @MainActor
    func deleteItem(_ item: MindCell.Model)
    
}

protocol IMindsListPresenter: AnyObject {
    
    @MainActor
    func viewDidLoad()
    
    @MainActor
    func didTapAddNewMind()
    
    @MainActor
    func didSelectMind(at index: Int)
    
    @MainActor
    func didDeleteMind(at index: Int)
}

final class MindsListPresenter {
    
    weak var view: IMindsListView?
    weak var output: IMindsListOutput?
    private let viewModelFactory: IMindsListViewModelFactory
    private let mindService: MindServiceProtocol
    
    // Models
    private var models: [MindCell.Model] = []
    
    // MARK: - Init
    
    init(
        viewModelFactory: IMindsListViewModelFactory,
        mindService: MindServiceProtocol,
        output: IMindsListOutput?
    ) {
        self.viewModelFactory = viewModelFactory
        self.mindService = mindService
        self.output = output
    }
}

// MARK: - IMindsListPresenter

extension MindsListPresenter: IMindsListPresenter {
    
    @MainActor
    func viewDidLoad() {
        let minds = mindService.cachedMinds
        models = minds.map {
            self.viewModelFactory.makeViewModel($0)
        }
        view?.updateTableView(with: models)
    }

    
    func didTapAddNewMind() {
        output?.didSelectMind(with: nil)
    }
    
    @MainActor
    func didSelectMind(at index: Int) {
        let model = models[index]
        output?.didSelectMind(with: model.id)
    }
    
    @MainActor
    func didDeleteMind(at index: Int) {
        guard index < models.count else {
            return
        }
        let model = models.remove(at: index)
        Task { [weak self] in
            guard let self else { return }
            await mindService.deleteMind(withId: model.id)
        }
    }
}

// MARK: -  IMindsListModuleInput

extension MindsListPresenter: @preconcurrency IMindsListModuleInput {
    
    @MainActor
    func didSaveMind() {
        let minds = mindService.cachedMinds
        models = minds.map {
            self.viewModelFactory.makeViewModel($0)
        }
        view?.updateTableView(with: models)
    }
}

extension MindsListPresenter: MindServiceDelegate {
    
    @MainActor
    func didReloadCache() {
        let minds = mindService.cachedMinds
        models = minds.map { self.viewModelFactory.makeViewModel($0) }
        view?.updateTableView(with: models)
    }
}
