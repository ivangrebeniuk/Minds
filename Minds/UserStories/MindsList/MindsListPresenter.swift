//
//  MindsListPresenter.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation

protocol IMindsListOutput: AnyObject {
    
    func didSelectMind(with id: UUID)
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
    private var models: [MindCell.Model] = []
    
    // MARK: - Init
    
    init(
        viewModelFactory: IMindsListViewModelFactory,
        output: IMindsListOutput?
    ) {
        self.viewModelFactory = viewModelFactory
        self.output = output
    }
    
    // MARK: - Private
    
    private func makeViewModels() {
        models.append(.init(title: "Заметка 1", text: nil))
        models.append(.init(title: "Заметка 2", text: "Как делашки, пес?"))
        models.append(.init(title: "Заметка 3", text: "Лупа лупа лупа"))
    }
}

// MARK: - IMindsListPresenter

extension MindsListPresenter: IMindsListPresenter {
    
    func viewDidLoad() {
        makeViewModels()
        view?.updateTableView(with: models)
    }
    
    func didTapAddNewMind() {
        // TEMPORARY SOLUTION
        let newModel = MindCell.Model(title: "Новая заметка", text: "Тест тест тест")
        models.insert(newModel, at: 0)
        view?.insertItem(newModel)
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
        view?.deleteItem(model)
    }
}
