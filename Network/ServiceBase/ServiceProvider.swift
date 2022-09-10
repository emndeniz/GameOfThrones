//
//  ServiceProvider.swift
//  GameOfThrones
//
//  Created by Emin on 8.09.2022.
//

import Foundation


/// Service Results Enum will return easy to undestand API responses to upper layers.
enum ServiceResult<T> {
    case success(T)
    case failure(Error)
    case empty
}


/// Service Provider manages URLSession process
class ServiceProvider<T: ServiceBase> {
    var urlSession:URLSession
    
    init(urlSession: URLSession = .shared ) {
        self.urlSession = urlSession
    }
    
    
    /// Starts resuest flow given service with required parameters and returns result in completion block.
    /// - Parameters:
    ///   - service: Service Type
    ///   - decodeType: Decoder Type to return response
    ///   - completion: Completion with Service Result
    func request<U>(service:T, decodeType: U.Type, completion: @escaping ((ServiceResult<U>) -> Void)) where U: Codable {
        execute(service.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(decodeType, from: data)
                    completion(.success(response))
                }
                catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            case .empty:
                completion(.empty)
            }
        }
    }
    

    
    
    /// Executes given request.
    /// - Parameters:
    ///   - request: URLRequest
    ///   - deliveryQueue: DispatchQueue of the request, default is main.
    ///   - completion: Completion block.
    private func execute(_ request:URLRequest,
                             deliveryQueue:DispatchQueue = DispatchQueue.main,
                             completion: @escaping ((ServiceResult<Data>) -> Void)){
        
        urlSession.dataTask(with: request) { data, _ , error in
            
            if let error = error {
                deliveryQueue.async{
                    completion(.failure(error))
                }
            }else if let data = data {
                deliveryQueue.async{
                    completion(.success(data))
                }
            }else {
                deliveryQueue.async{
                    completion(.empty)
                }
            }
        }.resume()
    }
    
    

    
}


