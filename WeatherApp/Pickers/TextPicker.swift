
import UIKit

class TextPicker {
    static let defaultPicker = TextPicker()
    
    func getText(showPickerIn viewController: UIViewController, title: String, message: String, completion: ((_ text: String?, _ error: Errors?) -> ())?) {
        let alertController =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let alertOK = UIAlertAction(title: "Ok", style: .default) { alert in
            if let text = alertController.textFields?[0].text, text != "" {
                completion?(text, nil)
            } else {
                completion?(nil, .empty)
            }
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        viewController.present(alertController, animated: true)
    }
}
