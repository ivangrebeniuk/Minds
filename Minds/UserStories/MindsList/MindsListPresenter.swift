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
    
    func updateTableView(with: [MindCell.Model])
    
    func insertItem(_ item: MindCell.Model)
    
    func deleteItem(_ item: MindCell.Model)
    
}

protocol IMindsListPresenter: AnyObject {
    
    func viewDidLoad()
    
    func didTapAddNewMind()
    
    func didSelectMind(at index: Int)
    
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

extension MindsListPresenter: @preconcurrency IMindsListPresenter {
    
    @MainActor
    func viewDidLoad() {
        Task { [weak self] in
            guard let self else { return }
            let minds = mindService.cachedMinds
            models = minds.map {
                self.viewModelFactory.makeViewModel($0)
            }
            view?.updateTableView(with: models)
        }
    }

    
    func didTapAddNewMind() {
        output?.didSelectMind(with: nil)
    }
    
    func didSelectMind(at index: Int) {
        let model = models[index]
        output?.didSelectMind(with: model.id)
    }
    
    func didDeleteMind(at index: Int) {
        guard index < models.count else {
            return
        }
        let model = models.remove(at: index)
        Task { [weak self] in
            guard let self else { return }
            await mindService.deleteMind(withId: model.id)
            view?.deleteItem(model)
        }
    }
}

// MARK: -  IMindsListModuleInput

extension MindsListPresenter: @preconcurrency IMindsListModuleInput {
    
    @MainActor
    func didSaveNewMind() {
        Task { [weak self] in
            guard let self else { return }
            let minds = mindService.cachedMinds
            models = minds.map {
                self.viewModelFactory.makeViewModel($0)
            }
            view?.updateTableView(with: models)
        }
    }
}
