//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit
import CoreLocation
import SnapKit

class AllowDeviceLocationViewController: UIViewController {
    
    var data: Weather?
    var location: CurrentLocation?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    private lazy var allowLocationButton = CustomButton(title: "ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ УСТРОЙСТВА", titleColor: .white, bgColor: .orange, fontSize: 12, action: allowLocationButtonpressed)
    private lazy var dontAllowLocationButton = CustomButton(title: "НЕТ БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", titleColor: .white, bgColor: .systemBlue, fontSize: 12, alignment: .trailing, action: dontAllowLocationButtonpressed)

    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
        setupUI()
//        locationManager?.requestAlwaysAuthorization()
//        locationManager?.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DispatchQueue.main.async {
////            self.checkData()
//        }
        locationManager.requestLocation()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBlue
        view.addSubview(allowLocationButton)
        view.addSubview(dontAllowLocationButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
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
    
    private func checkLocation() {
//        if locationManager?.location != nil {
            let mainVC = MainViewController()
            navigationController?.pushViewController(mainVC, animated: true)
//        }
    }
    
//    func checkData() {
//        if locationManager?.location != nil {
//
//        }
//    }

    @objc
    private func allowLocationButtonpressed() {
//        locationManager?.requestAlwaysAuthorization()
//        locationManager?.startUpdatingLocation()
    }
    
    @objc
    private func dontAllowLocationButtonpressed() {
        
    }

}

extension AllowDeviceLocationViewController: CLLocationManagerDelegate {
    
    func download() {
        let myLatitude: String = String(format: "%f", (self.locationManager.location!.coordinate.latitude))
        let myLongitude: String = String(format:"%f", (self.locationManager.location!.coordinate.longitude))
        DownloadManager.defaultManager.downloadWeatherDataFromCoordinates(lat: myLatitude, lon: myLongitude) { [self] weatherData, error in
            guard let weatherData else { return }
            data = weatherData as? Weather
            if let data {
                CoreDataManager.defaultManager.addData(data: data) { success in
                    if success {
                        DispatchQueue.main.async {
                            self.checkLocation()
                        }
                    }
                }
            }
        }
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(1234)
//        let myLatitude: String = String(format: "%f", (self.locationManager?.location!.coordinate.latitude)!)
//        let myLongitude: String = String(format:"%f", (self.locationManager?.location!.coordinate.longitude)!)
//        DownloadManager.defaultManager.downloadWeatherDataFromCoordinates(lat: myLatitude, lon: myLongitude) { [self] weatherData, error in
//            guard let weatherData else { return }
//            data = weatherData as? Weather
//            if let data {
//                CoreDataManager.defaultManager.addData(data: data) { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            self.checkLocation()
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            print("Определение локации невозможно")
        case .notDetermined:
            print("Определение локации не запрошено")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            download()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
}
