//
//  NetworkService.swift
//  KingfisherWithSNP
//
//  Created by Dmitry Kononov on 17.08.22.
//

import Foundation

final class NetworkService {
    private init() {}
    static var shared = NetworkService()
    
    private var URLStr = "https://stage.steemool.com/api/v1/sayings"
    
    func loadSaings(complition: @escaping (Result<[SayingModel], Error>) -> Void) {
        guard let url = URL(string: URLStr) else {return}
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let error = error {
                complition(.failure(error))
            }
            
            guard let data = data else {
                complition(.failure(MyError.noData))
                return
            }
            
            if let result = try? JSONDecoder().decode(SayingsResponce.self, from: data) {
                DispatchQueue.main.async {
                    complition(.success(result.data))
                }
            } else {
                complition(.failure(MyError.decoderFailure))
            }
            
        }.resume()
    }
}


enum MyError: Error {
    case noData
    case decoderFailure
}
