
import UIKit
import CoreLocation
import SnapKit
import CoreData

class AllowDeviceLocationViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private var titleLabelText: String = "Allow the Weather app to use your device's location data"
    private var descriptionLabelText: String = "To get more accurate weather forecasts while driving or traveling"
    private var locations: [City]? {
        return locationFetchResultsController?.fetchedObjects
    }
    private var locationFetchResultsController: NSFetchedResultsController<City>?
    private var latitude: Double? {
        return locationManager.location?.coordinate.latitude
    }
    private var longitude: Double? {
        return locationManager.location?.coordinate.longitude
    }
    
    private lazy var startImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "start")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleLabelText
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = descriptionLabelText
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    private lazy var allowLocationButton = CustomButton(title: "USE DEVICE LOCATION", titleColor: .white, bgColor: .orange, fontSize: 12, action: allowLocationButtonpressed)
    private lazy var dontAllowLocationButton = CustomButton(title: "NO, I WILL ADD LOCATIONS", titleColor: .white, bgColor: .systemBlue, fontSize: 12, alignment: .trailing, action: dontAllowLocationButtonpressed)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        locationManager.delegate = self
        initFetchResultsController()
        if locations != nil, locations?.count != 0 {
//            locationManager.requestAlwaysAuthorization()
//            locationManager.requestLocation()
            checkLocation(lat: latitude, lon: longitude)
        }
    }

    private func setupUI() {
        view.backgroundColor = standardBackgroundColor
        view.addSubview(startImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(allowLocationButton)
        view.addSubview(dontAllowLocationButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        startImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(45)
            make.width.equalTo(320)
            make.height.equalTo(288)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(startImage.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerX.equalTo(startImage.snp.centerX)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
        allowLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(dontAllowLocationButton.snp.top).offset(-20)
            make.right.equalTo(-20)
            make.left.equalTo(20)
            make.height.equalTo(40)
        }
        dontAllowLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalTo(-20)
            make.left.equalTo(20)
            make.height.equalTo(40)
        }
    }
    
    func initFetchResultsController() {
        let firstFetchRequest = City.fetchRequest()

        firstFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        locationFetchResultsController = NSFetchedResultsController(fetchRequest: firstFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        locationFetchResultsController?.delegate = self
        try? locationFetchResultsController?.performFetch()
    }
    
    private func checkLocation(lat: Double?, lon: Double?) {
        let mainVC = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        mainVC.latitude = lat
        mainVC.longitude = lon
        navigationController?.pushViewController(mainVC, animated: true)
    }

    @objc
    private func allowLocationButtonpressed() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    @objc
    private func dontAllowLocationButtonpressed() {
        let emptyLocationVC = EmptyLocationViewController()
        navigationController?.pushViewController(emptyLocationVC, animated: true)
    }

}

extension AllowDeviceLocationViewController: CLLocationManagerDelegate {
    
    func download() {
        if locations != nil, locations?.count != 0 {
            return
        }
        if let latitude, let longitude {
            let myLatitude: String = String(format: "%f", (latitude))
            let myLongitude: String = String(format:"%f", (longitude))
            DownloadManager.defaultManager.downloadWeatherDataFromCoordinates(lat: myLatitude, lon: myLongitude) { [self] weatherData, error in
                guard let weatherData else { return }
                let data = weatherData as? Weather
                if let data {
                    CoreDataManager.defaultManager.addData(data: data) { success in
                        if success {
                            DispatchQueue.main.async {
                                self.checkLocation(lat: latitude, lon: longitude)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            print("Location cannot be determined")
        case .notDetermined:
            print("Location not requested")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        download()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        
    }
    
}
