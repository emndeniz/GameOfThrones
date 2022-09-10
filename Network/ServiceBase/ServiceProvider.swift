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
    case failure(APIError)
}

/// Customized APIErrors for the app
enum APIError: Error {
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful(Error)
    var localizedDescription: String {
        switch self {
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
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
                    Logger.log.debug("Successfull response received, response:", context: response)
                    completion(.success(response))
                }
                catch let error{
                    Logger.log.error("Failed to decode received data :", context: error)
                    completion(.failure(.jsonConversionFailure))
                }
            case .failure(let error):
                completion(.failure(error))
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
        
        Logger.log.debug("App will send request, request:", context: request)
        urlSession.dataTask(with: request) { data, response , error in
            
            if let error = error {
                deliveryQueue.async{
                    Logger.log.error("Error recevied on request, error:", context: error)
                    completion(.failure(.responseUnsuccessful(error)))
                }
            }else if let data = data {
                deliveryQueue.async{
                    completion(.success(data))
                }
            }else {
                deliveryQueue.async{
                    Logger.log.error("Invalid data received, response:", context: response)
                    completion(.failure(.invalidData))
                }
            }
        }.resume()
    }
    
    

    
}


