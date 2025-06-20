//
//  DataManagerError.swift
//  
//
//  Created by aibaranchikov on 20.06.2025.
//

import CoreData

enum DataManagerError: Error {
    case fetchError(entityName: String, payload: DataManagerErrorPayload? = nil)
    case emptyResult(payload: DataManagerErrorPayload? = nil)
}

struct DataManagerErrorPayload: LocalizedError {
    let context: NSManagedObjectContext
    var error: Error = NSError(domain: "DataManagerErrorPayload", code: 0, userInfo: nil)
    var errorDescription: String? {
        return error.localizedDescription
    }
}
