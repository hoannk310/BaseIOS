//
//  APIError.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/5/25.
//

enum APIError: Error {
    case networkError(Error)
    case serverError(Int, String)
    case decodingError(Error)
    case unknown
    case invalidRequest
    case unauthorized
    case forbidden
    case notFound
    case methodNotAllowed
    case internalServerError
    case serviceUnavailable
    
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
          switch (lhs, rhs) {
          case (.networkError(let lhsError), .networkError(let rhsError)):
              return lhsError.localizedDescription == rhsError.localizedDescription
          case (.serverError(let lhsCode, let lhsMessage), .serverError(let rhsCode, let rhsMessage)):
              return lhsCode == rhsCode && lhsMessage == rhsMessage
          case (.decodingError(let lhsError), .decodingError(let rhsError)):
              return lhsError.localizedDescription == rhsError.localizedDescription
          case (.unknown, .unknown),
               (.invalidRequest, .invalidRequest),
               (.unauthorized, .unauthorized),
               (.forbidden, .forbidden),
               (.notFound, .notFound),
               (.methodNotAllowed, .methodNotAllowed),
               (.internalServerError, .internalServerError),
               (.serviceUnavailable, .serviceUnavailable):
              return true
          default:
              return false
          }
      }
}
