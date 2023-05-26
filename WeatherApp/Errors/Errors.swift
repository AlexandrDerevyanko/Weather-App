//
//  Errors.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 17.04.2023.
//

import Foundation

enum Errors: Error {
    case empty
    case unexpected
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty:
            return NSLocalizedString("Похоже, вы оставили пустое поле",
                                     comment: "")
        case .unexpected:
            return NSLocalizedString("Что то пошло не так",
                                     comment: "")
        }
    }
}
