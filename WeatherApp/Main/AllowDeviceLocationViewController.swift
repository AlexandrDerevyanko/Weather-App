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
    
    var locationManager: CLLocationManager?
    
    private lazy var allowLocationButton = CustomButton(title: "ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ УСТРОЙСТВА", titleColor: .white, bgColor: .orange, fontSize: 12, action: allowLocationButtonpressed)
    private lazy var dontAllowLocationButton = CustomButton(title: "НЕТ БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", titleColor: .white, bgColor: .systemBlue, fontSize: 12, alignment: .trailing, action: dontAllowLocationButtonpressed)

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        setupUI()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.checkData()
        }
        
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
        if locationManager?.location != nil {
            let mainVC = MainViewController()
            navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    func checkData() {
        if locationManager?.location != nil {
            
        }
    }

    @objc
    private func allowLocationButtonpressed() {
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    @objc
    private func dontAllowLocationButtonpressed() {
        
    }

}

extension AllowDeviceLocationViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLatitude: String = String(format: "%f", (self.locationManager?.location!.coordinate.latitude)!)
        let myLongitude: String = String(format:"%f", (self.locationManager?.location!.coordinate.longitude)!)

        DownloadManager.defaultManager.downloadWeatherDataFromCoordinates(lat: myLatitude, lon: myLongitude) { weatherData, error in
            guard let weatherData else { return }
            CoreDataManager.defaultManager.dataUpload(data: weatherData as! Weather) { success in
                if success {
                    DispatchQueue.main.async {
                        self.checkLocation()
                    }

                }
            }
        }
    }
    
}
