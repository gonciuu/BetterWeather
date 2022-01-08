import Foundation


struct ApiManager {
    
    func fetchWeather(completion: @escaping (Result<Weather, Error>) -> Void) {
        
        
        let url = URL(string:"https://api.weatherapi.com/v1/forecast.json?key=&q=London&days=3&aqi=no&alerts=no")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          if let error = error {
            completion(.failure(error))
          }
          if let data = data {
              print(data)
            do {
                
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                print(weather)
              completion(.success(weather))
            } catch let decoderError {
              completion(.failure(decoderError))
            }
          }
        }.resume()
      }
    
}
