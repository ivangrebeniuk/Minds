//
//  MindDetailsPresenter.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation

protocol IMindDetailsOutput: AnyObject {
    
    @MainActor
    func didTapSaveButton()
    
    @MainActor
    func dismiss()
}

protocol IMindDetailsView: AnyObject {
    
    func updateUI(with text: String)
    
    func setUpEmptyState()
    
    func showErrorAlert(action: @escaping (() -> Void))
}

protocol IMindDetailsPresenter {
    @MainActor
    func viewDidLoad()
      
    @MainActor
    func didTapSaveButton(with text: String)
}

@MainActor
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
    
    private func getMindModel(byId id: UUID) {
        let minds = mindService.cachedMinds
        mindModel = minds.first(where: { $0.id == id })
    }
    
    private func saveNewMind(text: String) {
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
                view?.showErrorAlert { [weak self] in
                    guard let self else { return }
                    output?.dismiss()
                }
            }
        }
    }
    
    func updateMind(text: String) {
        Task { [weak self] in
            guard let self, var mindModel else { return }
            mindModel.timestamp = .now
            mindModel.text = text
            do {
                try await mindService.saveMind(mindModel)
                output?.didTapSaveButton()
            } catch {
                view?.showErrorAlert { [weak self] in
                    guard let self else { return }
                    output?.dismiss()
                }
            }
        }
    }
    
    private func checkTextExist(_ text: String) -> Bool {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            return true
        } else {
            return false
        }
    }
}

// MARK: - IMindDetailsPresenter

extension MindDetailsPresenter: IMindDetailsPresenter {
    
    func viewDidLoad() {
        guard let mindId else {
            view?.setUpEmptyState()
            return
        }

        getMindModel(byId: mindId)
        if let mindModel {
            view?.updateUI(with: mindModel.text)
        } else {
            view?.setUpEmptyState()
        }
    }
    
    func didTapSaveButton(with text: String) {
        guard checkTextExist(text) else {
            output?.dismiss()
            return
        }
        
        if mindId == nil {
            saveNewMind(text: text)
        } else {
            updateMind(text: text)
        }
    }
}
