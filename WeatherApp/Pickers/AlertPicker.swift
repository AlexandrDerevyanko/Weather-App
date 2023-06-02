
import Foundation
import UIKit

class AlertPicker {
    
    static let defaulPicker = AlertPicker()
    
    func errors(showIn viewController: UIViewController, error: Errors) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(alertOk)
        viewController.present(alertController, animated: true)
    }
}
