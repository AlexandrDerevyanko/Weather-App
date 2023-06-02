
import UIKit

class EmptyLocationViewController: UIViewController {
    
    private lazy var button = CustomButton(title: "Add location", titleColor: .white, bgColor: .systemBlue, action: buttonPressed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = standardBackgroundColor
        view.addSubview(button)
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    @objc
    private func buttonPressed() {
        TextPicker.defaultPicker.getText(showPickerIn: self, title: "Adding a new location", message: "Please enter city name") { text, error in
            if let error {
                AlertPicker.defaulPicker.errors(showIn: self, error: error)
                return
            }
            guard let text else { return }
            DownloadManager.defaultManager.downloadWeatherDataFromString(location: text) { weatherData, error in
                if let error {
                    DispatchQueue.main.async {
                        AlertPicker.defaulPicker.errors(showIn: self, error: error)
                        return
                    }
                }
                guard let weatherData else { return }
                CoreDataManager.defaultManager.addData(data: weatherData as! Weather) { success in
                    if success {
                        DispatchQueue.main.async {
                            let pagesVC = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                            self.navigationController?.pushViewController(pagesVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
}
