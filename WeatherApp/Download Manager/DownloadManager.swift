//
//  DownloadManager.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import Foundation


// https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=-16.516667&lon=-68.166667&altitude=4150



class DownloadManager {
    
    static let defaultManager = DownloadManager()
    
    func download(lat: String, lon: String, completion: ((_ weatherCodable: Any?, _ error: Error?) -> ())?) {
        
        let session = URLSession(configuration: .default)
        
        var url = URL(string: "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=\(lat)&lon=\(lon)")!
        print(url)
        session.dataTask(with: url) { data, response, error in
            
            if let error {
                print(error.localizedDescription)
                completion?(nil, error)
                return
            }
            
            guard let data else {
                print("data = nil")
                completion?(nil, Errors.unexpected)
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(Weather.self, from: data)
                completion?(weatherData, nil)
            } catch {
                print(error)
                completion?(nil, error)
            }
            
        }.resume()
    }
}
