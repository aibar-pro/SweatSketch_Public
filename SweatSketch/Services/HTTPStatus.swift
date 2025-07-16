//
// HTTPStatus.swift
// SweatSketch
//
// Created by aibaranchikov on 03.07.2025.
//

import SweatSketchSharedModule

public enum HTTPStatus: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case tooManyRequests = 429
    
    case internalServerError = 500
    case serviceUnavailable = 503
}

extension SweatSketchSharedModule.Ktor_httpHttpStatusCode {
    var swiftStatus: HTTPStatus? { HTTPStatus(rawValue: Int(value)) }
}

extension Error {
    var kotlinApiException: SweatSketchSharedModule.ApiException? {
        (self as NSError).kotlinException as? SweatSketchSharedModule.ApiException
    }
    
    var apiStatus: HTTPStatus? {
        kotlinApiException?.status.swiftStatus
    }

    var isApiError: Bool {
        kotlinApiException != nil
    }
}
