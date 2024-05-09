//
//  NetworkService.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import Foundation

class NetworkService {
    static func login(user: UserCredentialModel, completion: @escaping (Result<UserTokenModel, Error>) -> Void) {
        guard let url = URL(string: "http://0.0.0.0:8080/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, !data.isEmpty  else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(UserTokenModel.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
