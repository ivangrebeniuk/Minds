//
//  MindDetailsPresenter.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation

protocol IMindDetailsOutput: AnyObject {
        
    func didTapSaveButton()
}

protocol IMindDetailsView: AnyObject {
    
    func updateUI(with text: String)
    
    func setUpEmptyState()
}

protocol IMindDetailsPresenter {
    
    func viewDidLoad()
        
    func didTapSaveButton(with text: String)
}

final class MindDetailsPresenter {
    
    // Dependincies
    weak var view: IMindDetailsView?
    private let mindService: MindServiceProtocol
    private weak var output: IMindDetailsOutput?
    
    // Models
    private let mindId: UUID?
    private var mindModel: Mind?
    
    // MARK: - Init
    
    init(
        mindId: UUID?,
        mindService: MindServiceProtocol,
        output: IMindDetailsOutput?
    ) {
        self.mindId = mindId
        self.mindService = mindService
        self.output = output
    }
    
    // MARK: Private
    
    @MainActor
    private func getMindModel(byId id: UUID) {
        let minds = mindService.cachedMinds
        mindModel = minds.first(where: {
            $0.id == id
        })
    }
}

// MARK: - IMindDetailsPresenter

extension MindDetailsPresenter: @preconcurrency IMindDetailsPresenter {
    
    @MainActor
    func viewDidLoad() {
        guard let mindId else {
            view?.setUpEmptyState()
            return
        }
        Task {
            getMindModel(byId: mindId)
            if let mindModel {
                view?.updateUI(with: mindModel.text)
            } else {
                view?.setUpEmptyState()
            }
        }
    }
    
    @MainActor
    func didTapSaveButton(with text: String) {
        if mindId == nil {
            let newMind = Mind(
                id: UUID(),
                text: text,
                timestamp: .now
            )
            Task {
                do {
                    try await mindService.saveMind(newMind)
                    output?.didTapSaveButton()
                } catch {
                    print("Не удалось сохранить новую заметку")
                }
            }
        } else {
            mindModel?.text = text
            mindModel?.timestamp = .now
            Task { [weak self] in
                guard let self, var mindModel else { return }
                mindModel.timestamp = .now
                mindModel.text = text
                do {
                    try await mindService.saveMind(mindModel)
                    output?.didTapSaveButton()
                } catch {
                    print("Не удалось сохранить новую заметку")
                }
            }
        }
    }
}
