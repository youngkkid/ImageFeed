//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Илья Ануфриев on 19.02.2025.
//

import Foundation


enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in  // 2
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data)) // 3
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode))) // 4
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error))) // 5
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError)) // 6
            }
        })
        
        return task
    }
    
        func objectTask<T: Decodable>(
            for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
        ) -> URLSessionTask {
            let decoder = JSONDecoder()
            let task = data(for: request) { (result: Result<Data, Error>) in
                switch result {
                case .success(let responseData):
                    do {
                        let decodeData = try decoder.decode(T.self, from: responseData)
                        completion(.success(decodeData))
                                   } catch {
                            print("[URLSession.objectTask]: DecodingError - \(error.localizedDescription), Data \(String(data: responseData, encoding: .utf8) ?? "") ")
                                       completion(.failure(error))
                        }
                case .failure(let error):
                    print("[URLSession.objectTask]: NetworkError = \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            return task
        }
}
