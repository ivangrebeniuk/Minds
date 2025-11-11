//
//  MindService.swift
//  Minds
//
//  Created by Иван Гребенюк on 02.11.2025.
//

import Foundation

@MainActor
protocol MindServiceDelegate: AnyObject {
    
    func didReloadCache()
}

protocol MindServiceProtocol {
    
    @MainActor
    var cachedMinds: [Mind] { get }
        
    func saveMind(_ mind: Mind) async throws
    
    func deleteMind(withId id: UUID) async throws
}

final class MindService {
    
    weak var delegate: MindServiceDelegate?
    private let coreDataService: CoreDataServiceProtocol
    @MainActor
    private lazy var minds: [Mind] = []
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
        
        Task { [weak self] in
            await self?.reloadCache()
        }
    }
    
    // MARK: - Private
    
    private func fetchMinds() async -> [Mind] {
        do {
            let fetchRequest = MindDB.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            let mindDBs = try await coreDataService.fetch(fetchRequest: fetchRequest)
            return mindDBs.compactMap {
                guard let id = $0.id, let text = $0.text, let time = $0.timeStamp else {
                    return nil
                }
                return Mind(id: id, text: text, timestamp: time)
            }
        } catch {
            print("⚠️ Core Data fetch error: \(error)")
            return []
        }
    }
    
    private func reloadCache() async {
        let minds = await fetchMinds()
        await MainActor.run { [weak self] in
            self?.minds = minds
            self?.delegate?.didReloadCache()
        }
    }
}

// MARK: - MindServiceProtocol

extension MindService: MindServiceProtocol {
    
    @MainActor
    var cachedMinds: [Mind] {
        minds
    }
    
    func saveMind(_ mind: Mind) async throws {
        try await coreDataService.save { managedObjectContext in
            let fetchRequest = MindDB.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", mind.id as CVarArg)
            
            let mindsDB = try managedObjectContext.fetch(fetchRequest)
            
            if mindsDB.isEmpty {
                let mindDB = MindDB(context: managedObjectContext)
                mindDB.id = mind.id
                mindDB.text = mind.text
                mindDB.timeStamp = mind.timestamp
            } else {
                mindsDB.first?.text = mind.text
                mindsDB.first?.timeStamp = mind.timestamp
            }
        }
        await reloadCache()
    }
    
    func deleteMind(withId id: UUID) async throws {
        try await coreDataService.delete(with: id)
        await reloadCache()
    }
}
