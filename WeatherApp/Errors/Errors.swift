//
//  Errors.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 17.04.2023.
//

import Foundation
import UIKit

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

class AlertPicker {
    
    static let defaulAlert = AlertPicker()
    
    func errors(showIn viewController: UIViewController, error: Errors) {
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(alertOk)
        viewController.present(alertController, animated: true)
    }
}
