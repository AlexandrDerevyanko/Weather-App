
import Foundation

class DownloadManager {
    
    static let defaultManager = DownloadManager()
    
    func downloadWeatherDataFromCoordinates(lat: String, lon: String, completion: ((_ weatherData: Any?, _ error: Errors?) -> ())?) {
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=4d67135a96064f23bf673214232504&q=\(lat),\(lon)&days=3&aqi=no&alerts=no")
        if let unwrappedURL = url {
            session.dataTask(with: unwrappedURL) { data, response, error in
                
                if let error {
                    print(error.localizedDescription)
                    completion?(nil, Errors.unexpected)
                    return
                }
                
                guard let data else {
                    print("data = nil")
                    completion?(nil, Errors.unexpected)
                    return
                }
                
                do {
                    let weatherData = try JSONDecoder().decode(Weather.self, from: data)
                    if weatherData.current == nil {
                        completion?(nil, Errors.unexpected)
                        return
                    }
                    completion?(weatherData, nil)
                } catch {
                    print(error)
                    completion?(nil, Errors.unexpected)
                }
                
            }.resume()
        }
    }
    
    func downloadWeatherDataFromString(location: String, completion: ((_ weatherData: Any?, _ error: Errors?) -> ())?) {
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=4d67135a96064f23bf673214232504&q=\(location)&days=3&aqi=no&alerts=no")
        if let unwrappedURL = url {
            session.dataTask(with: unwrappedURL) { data, response, error in
                
                if let error {
                    print(error.localizedDescription)
                    completion?(nil, Errors.unexpected)
                    return
                }
                
                guard let data else {
                    print("data = nil")
                    completion?(nil, Errors.unexpected)
                    return
                }
                do {
                    let weatherData = try JSONDecoder().decode(Weather.self, from: data)
                    if weatherData.current == nil {
                        completion?(nil, Errors.unexpected)
                        return
                    }
                    completion?(weatherData, nil)
                } catch {
                    print(error)
                    completion?(nil, Errors.unexpected)
                }
                
            }.resume()
        }
    }
    
    func downloadImageData(urlString: String?, complition: @escaping (_ data: Data?) -> ()) {
        guard let urlString else { return }
        guard let url = URL(string: "https:\(urlString)") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            if let error {
                print(error)
                return
            }
            complition(data)
        }.resume()
    }
    
}
