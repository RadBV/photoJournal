//
//  PhotosPersistence.swift
//  photoJournal
//
//  Created by Radharani Ribas-Valongo on 10/10/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import Foundation

struct JournalPersistenceHelper {
    static let manager = JournalPersistenceHelper()

    func save(newJournal: PhotoJournal) throws {
        try persistenceHelper.save(newElement: newJournal)
    }

    func getJournals() throws -> [PhotoJournal] {
        return try persistenceHelper.getObjects()
    }
    
    func deleteJournal(date: Date) throws {
        do {
            let journal =  try getJournals()
            let newJournals = journal.filter { $0.date != date}
            try persistenceHelper.replace(elements: newJournals)
        }
    }
    
    private let persistenceHelper = PersistenceHelper<PhotoJournal>(fileName: "PhotoJournal.plist")

    private init() {}
}
