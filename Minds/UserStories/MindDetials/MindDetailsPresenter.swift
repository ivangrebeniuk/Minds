//
//  MindDetailsPresenter.swift
//  Minds
//
//  Created by Иван Гребенюк on 11.10.2025.
//

import Foundation

protocol IMindDetailsView: AnyObject {
    
    func updateUI(with text: String)
    
    func setUpEmptyState()
}

protocol IMindDetailsPresenter {
    
    func viewDidLoad()
    
    func didTapBackButton()
    
    func didTapSaveButton(with text: String)
}

final class MindDetailsPresenter {
    
    weak var view: IMindDetailsView?
    private let mindId: UUID?
    private var mindModel: MindModel?
    
    // MARK: - Init
    
    init(
        mindId: UUID?,
    ) {
        self.mindId = mindId
    }
}

extension MindDetailsPresenter: IMindDetailsPresenter {
    
    func viewDidLoad() {
        guard let mindId else {
            view?.setUpEmptyState()
            return
        }
        
        // тут надо достать из core data  модельку по mindId
        // Полученную модель Как будь-то бы модель сохраняем в переменную mindModel
        mindModel = MindModel(
            id: mindId,
            text: "Как будь-то бы мы достали текст из CoreData",
            time: .now
        )
        view?.updateUI(with: "Текст заметки из БД")
    }
        
    func didTapBackButton() {}
    

    func didTapSaveButton(with text: String) {
        if mindModel == nil {
            mindModel = MindModel(
                id: UUID(),
                text: text,
                time: .now
            )
            print("🔜Тут мы должны сохранить модельку в CoreData вызвав метод SaveMind")
        } else {
            mindModel?.text = text
            mindModel?.time = .now
            print("🔜Тут мы должны сохранить модельку в CoreData вызвав метод SaveMind")
        }
    }
}
