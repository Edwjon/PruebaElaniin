//
//  CustomError.swift
//  PruebaElaniin
//
//  Created by Edward Pizzurro on 1/17/23.
//

import Foundation

enum CustomError: Error {
    case missingIDorName
    case invalidURL(url: String)
    case missingData
    case decodingError(Error)
    case other(Error)

    var localizedDescription: String {
        switch self {
        case .missingIDorName:
            return "Missing ID or Name"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .missingData:
            return "Missing data"
        case .decodingError(let error):
            return "Decoding Error: \(error.localizedDescription)"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
