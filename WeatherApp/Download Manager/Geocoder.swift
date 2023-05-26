import Foundation

class GeocoderManager {
    
    static let defaultManager = GeocoderManager()

    func getData(lat: String, lon: String, completion: ((_ geocoderData: Any?, _ error: Error?) -> ())?) {
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://geocode-maps.yandex.ru/1.x/?apikey=7e7865d6-9bd6-494d-8191-9ac19f65814c&lang=en&format=json&geocode=\(lon),\(lat)")
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
                    let geocoderData = try JSONDecoder().decode(Geocoder.self, from: data)
                    completion?(geocoderData, nil)
                } catch {
                    print(error)
                    completion?(nil, Errors.unexpected)
                }
                
            }.resume()
        }
    }
    
}
