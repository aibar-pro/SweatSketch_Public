//
//  APIError.swift
//  SweatSketch
//
//  Created by aibaranchikov on 03.07.2025.
//

enum APIError: Error, CaseMatchable {
    case unauthorized(_ payload: Error? = nil)
    case notFound(_ payload: Error? = nil)
    case unknownError(_ payload: Error? = nil)
    
    func matchesCase(_ other: APIError) -> Bool {
        switch (self, other) {
        case (.unauthorized, .unauthorized), (.notFound, .notFound), (.unknownError, .unknownError): return true
            default: return false
        }
    }
}

extension APIError {
    static func map(_ error: Error) -> APIError {
        guard let status = error.apiStatus else { return APIError.unknownError(error) }
        
        switch status {
        case .notFound: return .notFound(error)
        case .unauthorized: return .unauthorized(error)
        default: return APIError.unknownError(error)
        }
    }
    
    static func unknown() -> APIError { .unknownError() }
}
